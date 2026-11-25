#!/usr/bin/env python3
"""Run a solver on benchmark sets on the local machine.

Drop-in replacement for submit-job.sh (the Slurm submitter used on the cluster)
that produces the same result layout, so cmpr.py can analyze it:

  WORKING_DIR/options
  WORKING_DIR/<set>/benchmarks                       copy of the set list
  WORKING_DIR/<set>/<benchmark path>/run.out         'c args: ...' + runexec-style measurements
  WORKING_DIR/<set>/<benchmark path>/output.log      solver stdout+stderr

Benchmark set lists (benchmark_set_<name>) are looked up in the current directory.
Measurements come from BenchExec's runexec when it is installed (as on the
cluster), otherwise from a fallback that enforces the CPU-time limit with
RLIMIT_CPU and the memory limit with RLIMIT_AS, and reads usage from wait4().
"""
import argparse
import os
import resource
import shlex
import shutil
import signal
import subprocess
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from os.path import commonprefix, dirname


def max_jobs_by_ram(mem_mb):
    """How many runs with mem_mb each fit into 90% of the RAM."""
    try:
        with open('/proc/meminfo') as f:
            total_kb = int(next(l for l in f if l.startswith('MemTotal')).split()[1])
        return max(1, int(total_kb / 1024 * 0.9 // mem_mb))
    except (OSError, StopIteration, ValueError):
        return 1


def default_jobs(mem_mb):
    return max(1, min(os.cpu_count() or 1, max_jobs_by_ram(mem_mb)))


def run_fallback(cmd, out_path, time_limit, mem_mb):
    """Run cmd with CPU/memory limits; return runexec-style result lines."""
    def limits():
        os.setsid()
        resource.setrlimit(resource.RLIMIT_CPU, (time_limit, time_limit + 1))
        m = mem_mb * 1024 * 1024
        resource.setrlimit(resource.RLIMIT_AS, (m, m))

    wall_limit = 2 * time_limit + 30          # safety net for processes that sleep/block
    start = time.monotonic()
    with open(out_path, 'ab') as out:
        p = subprocess.Popen(cmd, stdout=out, stderr=subprocess.STDOUT,
                             stdin=subprocess.DEVNULL, preexec_fn=limits)
        killed_wall = False
        while True:
            pid, status, ru = os.wait4(p.pid, os.WNOHANG)
            if pid:
                break
            if time.monotonic() - start > wall_limit:
                killed_wall = True
                try:
                    os.killpg(p.pid, signal.SIGKILL)
                except ProcessLookupError:
                    pass
            time.sleep(0.05)
        p.returncode = 0  # reaped by wait4 above
    wall = time.monotonic() - start
    # usage of the solver and all descendants it waited for
    cpu = ru.ru_utime + ru.ru_stime
    mem = ru.ru_maxrss * 1024
    try:  # kill leftovers of the process group
        os.killpg(p.pid, signal.SIGKILL)
    except ProcessLookupError:
        pass

    lines = [f'walltime={wall:.6f}s', f'cputime={cpu:.6f}s', f'memory={mem}B']
    if os.WIFSIGNALED(status):
        lines.append(f'exitsignal={os.WTERMSIG(status)}')
        failed = True
    else:
        lines.append(f'returnvalue={os.WEXITSTATUS(status)}')
        failed = os.WEXITSTATUS(status) != 0
    # Classify by measured usage, as runexec does: solvers react to SIGXCPU in
    # different ways (cvc5 aborts with SIGABRT, wrapper scripts exit with 152, ...).
    # The kernel sends SIGXCPU at the soft limit, but the usage that wait4 reports can be
    # a bit lower (e.g. 4.90 s at a 5 s limit), so a failure close to the limit counts too.
    if cpu >= time_limit - 0.05 or (failed and cpu >= 0.9 * time_limit):
        lines.append('terminationreason=cputime')
    elif killed_wall:
        lines.append('terminationreason=walltime')
    elif failed and (mem >= 0.95 * mem_mb * 1024 * 1024 or out_of_memory(out_path)):
        lines.append('terminationreason=memory')
    elif os.WIFSIGNALED(status) and os.WTERMSIG(status) == signal.SIGKILL:
        # SIGKILL that is neither our CPU nor our wall limit: the kernel OOM killer
        lines.append('terminationreason=memory')
    return '\n'.join(lines) + '\n'


OOM_MARKERS = (b'bad_alloc', b'out of memory', b'Cannot allocate memory',
               b'memory allocation of', b'MemoryError')


def out_of_memory(path):
    """RLIMIT_AS makes allocations fail before RSS reaches the limit: look for the message."""
    try:
        with open(path, 'rb') as f:
            f.seek(0, os.SEEK_END)
            f.seek(max(0, f.tell() - 65536))
            tail = f.read()
    except OSError:
        return False
    return any(m in tail for m in OOM_MARKERS)


def run_one(cmd, logdir, bench, args, runexec):
    os.makedirs(logdir, exist_ok=True)
    out_path = os.path.join(logdir, 'output.log')
    run_out = os.path.join(logdir, 'run.out')
    header = (f'c host:       {os.uname().nodename}\n'
              f'c start:      {time.ctime()}\n'
              f'c command:    {shlex.join(cmd)}\n'
              f'c args:       {bench}\n')
    if runexec:
        rx = [runexec, '--read-only-dir', '/', '--overlay-dir', '/home',
              '--full-access-dir', logdir, '--dir', logdir, '--output', out_path,
              '--timelimit', str(args.time_limit), '--memlimit', f'{args.memory_limit}MB',
              '--'] + cmd
        r = subprocess.run(rx, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        result = r.stdout.decode(errors='replace')
    else:
        open(out_path, 'wb').close()
        result = run_fallback(cmd, out_path, args.time_limit, args.memory_limit)
    with open(run_out, 'w') as f:
        f.write(header + result + 'c done\n')


def main():
    ap = argparse.ArgumentParser(description=__doc__,
                                 formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument('executable')
    ap.add_argument('--solver-options', default='')
    ap.add_argument('--benchmark-sets', required=True, help='space-separated set names')
    ap.add_argument('--time-limit', type=int, default=60, help='CPU seconds per benchmark')
    ap.add_argument('--memory-limit', type=int, default=8000, help='MB per benchmark')
    ap.add_argument('--working-dir', required=True)
    ap.add_argument('--jobs', type=int, default=0,
                    help='parallel runs (default: min(#cpus, RAM / memory limit))')
    ap.add_argument('--no-runexec', action='store_true', help='use the fallback even if runexec exists')
    args = ap.parse_args()

    exe = os.path.abspath(args.executable)
    if not os.access(exe, os.X_OK):
        sys.exit(f"executable '{exe}' does not exist or is not executable")
    sets = args.benchmark_sets.split()
    lists = {}
    for s in sets:
        p = os.path.abspath(f'benchmark_set_{s}')
        if not os.path.isfile(p):
            sys.exit(f"benchmark set '{s}': {p} not found (run scripts/setup.sh)")
        lists[s] = p
    runexec = None if args.no_runexec else shutil.which('runexec')
    jobs = args.jobs or default_jobs(args.memory_limit)
    if jobs > max_jobs_by_ram(args.memory_limit):
        print(f'warning: {jobs} parallel runs x {args.memory_limit} MB exceed the RAM of this '
              f'machine; memory-hungry solvers will be killed by the OOM killer or swap, '
              f'which changes the results', file=sys.stderr)

    wd = os.path.abspath(args.working_dir)
    os.makedirs(wd, exist_ok=True)
    opts = shlex.split(args.solver_options)
    with open(os.path.join(wd, 'options'), 'w') as f:
        f.write(shlex.join(sys.argv) + '\n\n'
                f'cpu time limit:  {args.time_limit}\n'
                f'memory limit:    {args.memory_limit}\n'
                f'command:         {os.path.basename(exe)} {args.solver_options}\n'
                f'runner:          {"runexec" if runexec else "fallback (rlimits)"}, {jobs} parallel\n')

    tasks = []
    for s in sets:
        sdir = os.path.join(wd, s)
        os.makedirs(sdir, exist_ok=True)
        shutil.copy(lists[s], os.path.join(sdir, 'benchmarks'))
        benches = [l.strip() for l in open(lists[s]) if l.strip()]
        prefix = dirname(commonprefix(benches))
        prefix = prefix + '/' if prefix else ''
        for b in benches:
            logdir = os.path.join(sdir, b[len(prefix):])
            if os.path.isfile(os.path.join(logdir, 'run.out')):
                continue  # finished in an earlier, interrupted run
            tasks.append(([exe] + opts + [b], logdir, b))

    print(f'{os.path.basename(wd)}: {len(tasks)} runs, {jobs} in parallel, '
          f'{"runexec" if runexec else "fallback limits"}', flush=True)
    done = 0
    with ThreadPoolExecutor(max_workers=jobs) as pool:
        futs = [pool.submit(run_one, c, l, b, args, runexec) for c, l, b in tasks]
        for fut in as_completed(futs):
            fut.result()
            done += 1
            if done % 100 == 0 or done == len(tasks):
                print(f'  {done}/{len(tasks)}', flush=True)


if __name__ == '__main__':
    main()
