#!/bin/bash
# Rebuild the WebAssembly solvers used by index.html (writes wasm/).
#
# usage: bash web/build-wasm.sh CVC5_SRC PARABIT_SRC
#   CVC5_SRC     cvc5 checkout with T_PBV (branch pbv-theory, commit 080de3aef)
#   PARABIT_SRC  ParaBit source (CAV'26 artifact, version 0.1.6)
#
# Requirements: emsdk (https://emscripten.org, tested with 7.0.1, `source emsdk_env.sh`),
# cmake, python3, rustup with the wasm32-wasip1 target.
set -euo pipefail
ART="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CVC5_SRC="$(realpath "$1")"; PARABIT_SRC="$(realpath "$2")"
WORK="${WORK:-$ART/web/build}"
mkdir -p "$WORK" "$ART/wasm"

# ---------------------------------------------------------------- cvc5
rm -rf "$WORK/cvc5"; cp -r "$CVC5_SRC" "$WORK/cvc5"; rm -rf "$WORK/cvc5/build"*
cd "$WORK/cvc5"
patch -p1 < "$ART/web/patches/cvc5-wasm.patch"     # missing includes (clang/libc++ is stricter than gcc)
./configure.sh production --static --static-binary --auto-download --name=build-wasm --wasm=JS \
  --wasm-flags='-s MODULARIZE=1 -s EXPORT_NAME=createCvc5 -s ENVIRONMENT=worker -s INVOKE_RUN=0 -s EXIT_RUNTIME=1 -s EXPORTED_RUNTIME_METHODS=["callMain","FS"] -s INITIAL_MEMORY=64MB -s ALLOW_MEMORY_GROWTH=1 -s MAXIMUM_MEMORY=4GB -s STACK_SIZE=16MB -s NO_DISABLE_EXCEPTION_CATCHING=1'
cd build-wasm
# The PBV rewriters are generated into the build tree, but kinds.toml validation looks
# for them in the source tree: generate them first and link them there.
make -f src/theory/CMakeFiles/gen-theory.dir/build.make \
  src/theory/pbv/theory_pbv_rewriter.h src/theory/pbv/theory_piand_rewriter.h src/theory/pbv/theory_exp_rewriter.h
for r in pbv piand exp; do ln -sf "$PWD/src/theory/pbv/theory_${r}_rewriter.h" ../src/theory/pbv/; done
# LibPoly (auto-downloaded) misses <cstdlib> for free(): the first pass downloads it and
# stops there; patch it, then build everything.
make -j"$(nproc)" Poly-EP || true
for f in deps/src/Poly-EP/src/polyxx/*.cpp; do grep -q '<cstdlib>' "$f" || sed -i '1i #include <cstdlib>' "$f"; done
make -j"$(nproc)"
cp bin/cvc5.js bin/cvc5.wasm "$ART/wasm/"

# ---------------------------------------------------------------- ParaBit
rm -rf "$WORK/parabit"; cp -r "$PARABIT_SRC" "$WORK/parabit"; rm -rf "$WORK/parabit/target"
cd "$WORK/parabit"
patch -p1 < "$ART/web/patches/parabit-wasm.patch"  # drop unused tqdm (no terminal on WASI); print unsat/unknown like the paper binary
rustup target add wasm32-wasip1
cargo build --release --target wasm32-wasip1
cp target/wasm32-wasip1/release/parabit.wasm "$ART/wasm/"

ls -la "$ART/wasm"
