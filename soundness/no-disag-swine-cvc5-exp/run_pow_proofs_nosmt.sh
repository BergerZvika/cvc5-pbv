#!/usr/bin/env bash
# Solver-free version of run_pow_proofs.sh: explain why every exponent t in (** s t)
# is non-negative for the LoAT and PURRS benchmarks, without calling an SMT solver.
# Only needs python3 (standard library).  Results go to $OUT (default: results/):
#   summary.txt, vacuous_files.txt, vacuous_report.txt, <benchmark>.proof.txt
#
# Usage: pow_proofs_nosmt/run_pow_proofs_nosmt.sh [OUT_DIR] [extra args, e.g. --json]
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
OUT="$(realpath -m "${1:-$HERE/results}")"
shift || true
cd "$HERE/.."      # benchmark root, so proofs are named LoAT/..., PURRS/...

PYTHON="${PYTHON:-python3}"
command -v "$PYTHON" >/dev/null || { echo "error: $PYTHON not found" >&2; exit 1; }
"$PYTHON" -c 'import sys; sys.exit(sys.version_info < (3, 8))' ||
    { echo "error: python >= 3.8 required" >&2; exit 1; }

for d in LoAT PURRS; do
    [ -d "$d" ] || { echo "error: benchmark directory $d not found" >&2; exit 1; }
done

"$PYTHON" "$HERE/explain_pow_nonneg_nosmt.py" --out "$OUT" "$@" LoAT PURRS
head -1 "$OUT/summary.txt"
head -1 "$OUT/vacuous_report.txt"
