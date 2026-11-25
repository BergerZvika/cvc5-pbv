#!/usr/bin/env bash
#
# Run parabit on a single benchmark and report an SMT solver style result.
#
# parabit itself prints the proof certificate on stdout (and its logs on
# stderr), and exits non-zero when it cannot prove the equivalence.  This
# wrapper sends both of those to a separate output channel and prints one
# machine readable word on the screen:
#
#   unsat    -- the equivalence was proven
#   unknown  -- parabit could not prove it (saturation, timeout, memory, crash)
#
# Usage:
#   parabit_solve.sh [-o FILE] [-b BINARY] [-t SECONDS] FILE [parabit args...]
#
#   -o FILE     where parabit's certificate and logs go (default: /dev/null)
#   -b BINARY   path to the parabit binary
#               (default: ../parabit/target/release/parabit next to this script)
#   -t SECONDS  kill parabit after SECONDS and report unknown (default: no limit)
#
# Any arguments after FILE are passed straight to parabit, e.g.
#   parabit_solve.sh -o proof.txt bench.bwlang check-equals --skip-proof

set -u

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

out_channel="/dev/null"
#binary="$script_dir/../parabit/target/release/parabit"
binary="/home/fast/zviarib/parabit"
time_limit=""

usage() {
    sed -n '3,22p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'
}

while getopts ":o:b:t:h" opt; do
    case "$opt" in
        o) out_channel="$OPTARG" ;;
        b) binary="$OPTARG" ;;
        t) time_limit="$OPTARG" ;;
        h) usage; exit 0 ;;
        :) echo "missing argument for -$OPTARG" >&2; exit 2 ;;
        \?) echo "unknown option -$OPTARG" >&2; usage >&2; exit 2 ;;
    esac
done
shift $((OPTIND - 1))

if [ $# -lt 1 ]; then
    usage >&2
    exit 2
fi

input_file="$1"
shift

if [ ! -x "$binary" ]; then
    echo "parabit binary not found or not executable: $binary" >&2
    echo "build it with 'cargo build --release' in the parabit directory" >&2
    exit 2
fi

if [ ! -f "$input_file" ]; then
    echo "input file not found: $input_file" >&2
    exit 2
fi

cmd=("$binary" "$input_file" "$@")
if [ -n "$time_limit" ]; then
    cmd=(timeout "$time_limit" "${cmd[@]}")
fi

if ! : 2>/dev/null >>"$out_channel"; then
    echo "cannot write to output channel: $out_channel" >&2
    exit 2
fi

# the certificate (stdout) and the logs (stderr) both go to the output channel,
# and so does the shell's own report when parabit is killed by a signal, so that
# the only thing on the screen is the one line result
{ "${cmd[@]}" >>"$out_channel" 2>&1; } 2>>"$out_channel"
status=$?

if [ "$status" -eq 0 ]; then
    echo "unsat"
else
    echo "unknown"
fi
