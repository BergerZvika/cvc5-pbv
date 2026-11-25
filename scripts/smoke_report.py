#!/usr/bin/env python3
"""Summarize a --smoke-test run (partial Table 11, eval_pbv.tex) and compare it with
the paper's verdicts in benchmarks/smoke-expected.tsv.

usage: python3 scripts/smoke_report.py [RESULTS_DIR]     (default: results/smoke)

Prints solved benchmarks per set and configuration as "got/expected", then every
benchmark whose verdict differs from the paper. A wrong answer (sat vs. unsat) is a
soundness problem; a timeout where the paper solved (or vice versa) can come from
a slower or faster machine.
"""
import os
import re
import sys
from collections import defaultdict

ART = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
CFGS = ['pbvsolver+', 'cvc5', 'cvc5-exp', 'cvc5+rr', 'cvc5+lr', 'cvc5+piand', 'cvc5-pbv']
HEAD = ['Pbv+', 'cvc5', 'cvc5-exp', '+rr', '+lr', '+piand', 'cvc5-pbv']   # column names
MARK = 'benchmarks/'   # benchmark paths are compared from here on


def key(path):
    i = path.find(MARK)
    return path[i:] if i >= 0 else path


def verdict(d):
    """sat / unsat / timeout / memout / error, as in the expected file ('cputime' = timeout)."""
    try:
        run = open(os.path.join(d, 'run.out'), errors='replace').read()
    except OSError:
        return None, None
    m = re.search(r'^c args:\s+(\S+)', run, re.M)
    bench = key(m.group(1)) if m else None
    m = re.search(r'^terminationreason=(\S+)', run, re.M)
    if m:
        return bench, {'cputime': 'timeout', 'walltime': 'timeout', 'memory': 'memout'}.get(m.group(1), 'error')
    try:
        for line in open(os.path.join(d, 'output.log'), errors='replace'):
            if line.strip() in ('sat', 'unsat'):
                return bench, line.strip()
    except OSError:
        pass
    return bench, 'error'


def main():
    res_dir = os.path.abspath(sys.argv[1] if len(sys.argv) > 1 else os.path.join(ART, 'results', 'smoke'))
    expected, sets = {}, []
    for line in open(os.path.join(ART, 'benchmarks', 'smoke-expected.tsv')):
        if line.startswith('#') or line.startswith('set\t'):
            continue
        f = line.rstrip('\n').split('\t')
        if f[0] not in sets:
            sets.append(f[0])
        for c, v in zip(CFGS, f[2:]):
            expected[(c, key(f[1]))] = ('timeout' if v == 'cputime' else v, f[0])

    got = {}
    for c in CFGS:
        for root, _, files in os.walk(os.path.join(res_dir, c)):
            if 'run.out' in files:
                b, v = verdict(root)
                if b:
                    got[(c, b)] = v

    solved = defaultdict(int)
    exp_solved = defaultdict(int)
    diffs, missing = [], 0
    for (c, b), (ev, s) in expected.items():
        exp_solved[(c, s)] += ev in ('sat', 'unsat')
        v = got.get((c, b))
        if v is None:
            missing += 1
            continue
        solved[(c, s)] += v in ('sat', 'unsat')
        if v != ev:
            wrong = {v, ev} == {'sat', 'unsat'}
            diffs.append((wrong, c, b, v, ev))

    n = defaultdict(int)
    for (c, b), (_, s) in expected.items():
        if c == CFGS[0]:
            n[s] += 1
    w = max(len(s) for s in sets) + 2
    print('solved: this run / paper' + ('' if not missing else f'   ({missing} runs missing)'))
    print('set'.ljust(w) + '#'.rjust(3) + ''.join(h.rjust(10) for h in HEAD))
    for s in sets + ['total']:
        row = sets if s == 'total' else [s]
        cells = []
        for c in CFGS:
            g = sum(solved[(c, x)] for x in row)
            e = sum(exp_solved[(c, x)] for x in row)
            cells.append(f'{g}/{e}'.rjust(10))
        print(s.ljust(w) + str(sum(n[x] for x in row)).rjust(3) + ''.join(cells))

    if diffs:
        print(f'\n{len(diffs)} verdicts differ from the paper (config, benchmark, this run, paper):')
        for wrong, c, b, v, ev in sorted(diffs, key=lambda d: (not d[0], d[1], d[2])):
            print(f"  {'WRONG ANSWER ' if wrong else ''}{c}  {b}  {v}  (paper: {ev})")
    elif not missing:
        print('\nall verdicts match the paper')
    return 1 if any(d[0] for d in diffs) else 0


if __name__ == '__main__':
    sys.exit(main())
