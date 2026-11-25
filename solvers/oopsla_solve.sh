#!/usr/bin/env bash
#
# Run an Unbounded-Ours solver (e.g. oopsla-ric3 / oopsla-kind) on a single
# benchmark and print only the value of its "Result:" line (e.g. sat, unsat,
# or "error: formula is outside the automata-decidable fragment").
# Prints "unknown" if the solver crashed or produced no Result line.
#
# Usage:
#   oopsla_solve.sh SOLVER FILE [blasewuzla args...]
#
#   SOLVER   path to the solver, e.g. /home/zvbe/benchmarks/solvers/oopsla-ric3
#

if [[ $# -lt 2 || ! -x "$1" ]]; then
  echo "usage: $(basename "$0") SOLVER FILE [blasewuzla args...]  (SOLVER must be an executable path)" >&2
  exit 2
fi
SOLVER="$1"; shift

RESULT="$("$SOLVER" "$@" 2>&1 | sed -n 's/^Result: //p' | tail -n 1)"
echo "${RESULT:-unknown}"
