#!/bin/bash

SWINE_BIN="/home/fast/zviarib/swine-z3"
BENCHMARK="${@: -1}"
SOLVER_ARGS=("${@:1:$#-1}")

TRANSLATED_BENCHMARK="$(echo "$BENCHMARK" | tr '/' '_')"
TRANSLATED_BENCHMARK="$TRANSLATED_BENCHMARK.exp.smt2"
TRANSLATED_BENCHMARK="/tmp/$TRANSLATED_BENCHMARK"


# translate
cat "$BENCHMARK" | \
  sed -e 's/\*\*/exp/g' > "$TRANSLATED_BENCHMARK"


# solve
${SWINE_BIN} "${SOLVER_ARGS[@]}" "$TRANSLATED_BENCHMARK"
