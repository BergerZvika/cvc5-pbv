#!/bin/bash
# Prepare the artifact for running (idempotent; re-run after moving the artifact).
#
#   data/                    benchmarks unpacked from benchmarks/sets/*.tar.gz
#   data/benchmark_set_*     the set lists of benchmark_sets/, with paths into data/
#   bin/                     solvers/, with the wrappers' absolute paths pointing into bin/
#
# usage: bash scripts/setup.sh [SET...]     (default: every set in benchmarks/sets/)
set -euo pipefail

ART="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ORIG=/home/fast/zviarib          # prefix of the paths on the cluster where the artifact was built

# ---- benchmarks
mkdir -p "$ART/data"
if [ $# -gt 0 ]; then sets=("$@"); else
  sets=(); for f in "$ART"/benchmarks/sets/*.tar.gz; do s=$(basename "$f"); sets+=("${s%.tar.gz}"); done
fi
for s in "${sets[@]}"; do
  a="$ART/benchmarks/sets/$s.tar.gz"
  [ -f "$a" ] || { echo "no archive for set '$s' ($a)" >&2; exit 1; }
  echo "unpacking $s"
  tar -xzf "$a" -C "$ART/data" --exclude="benchmark_set_$s"
  # set list with local paths (submit-job.sh requires a trailing newline)
  sed "s#^$ORIG/#$ART/data/#" "$ART/benchmark_sets/benchmark_set_$s" > "$ART/data/benchmark_set_$s"
  [ -z "$(tail -c1 "$ART/data/benchmark_set_$s")" ] || echo >> "$ART/data/benchmark_set_$s"
  missing=$(while read -r b; do [ -f "$b" ] || echo "$b"; done < "$ART/data/benchmark_set_$s" | wc -l)
  [ "$missing" -eq 0 ] || { echo "  $missing benchmark files of '$s' are missing" >&2; exit 1; }
done

# ---- solvers
mkdir -p "$ART/bin"
for f in "$ART"/solvers/*; do
  n=$(basename "$f")
  if head -c 2 "$f" | grep -q '#!' && [ "$(stat -c %s "$f")" -lt 100000 ]; then
    # small wrapper script: redirect cluster paths into bin/
    sed "s#$ORIG/#$ART/bin/#g" "$f" > "$ART/bin/$n"
  else
    ln -sf "../solvers/$n" "$ART/bin/$n"
  fi
  chmod +x "$ART/bin/$n" "$f"
done

echo "setup done: ${#sets[@]} benchmark sets in $ART/data, solvers in $ART/bin"
