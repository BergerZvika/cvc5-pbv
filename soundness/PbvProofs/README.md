# Lean soundness proofs for the EXP/PBV paper (`exp-pbv-paper/main.tex`)

Lean 4.35.0 + Mathlib. Build: `lake build` (0 errors, 0 `sorry`, no `native_decide`, no custom axioms).

Semantics (`PbvProofs/Defs.lean`): Lean `Int` `/` `%` = SMT-LIB Euclidean `div`/`mod` with
total division by zero (`x/0=0`, `x%0=x`); `smtExp` = SMT-LIB `**` incl. negative exponents;
PBV = `BitVec w` with `w` universally quantified; `piand` = bitwise AND of the k-bit residues.

| File | Paper section | Theorems |
|---|---|---|
| ExpLemmas.lean | Table `tab:lem-exp` (29 schemas) | 60 |
| ModReduce.lean | Table `tab:mod-reduce` | 21 |
| Fermat.lean | Sect. `sec:exp-fermat` (vacuity pass soundness, CRT, koat_141 example) | 11 |
| MwRewrites.lean | Table `tab:mw-rewrites` + the two udiv identities (rules that are also RARE rules: see RarePbv.lean) | 38 |
| Learned.lean | Table `tab:mw-learned` | 71 |
| Piand.lean | Table `tab:lem-piand-new` (complement) | 5 |
| RarePbv.lean | `tables/rr-pbv.tex` (cvc5 `src/theory/pbv/rewrites`), **generated** | 63 + 3 `_wf` |
| RarePiand.lean | `tables/rr-piand.tex` (cvc5 `src/theory/pbv/rewrites-piand`), **generated** | 7 |
| RareExp.lean | Table `tab:exp-rewrites` = `tables/rr-exp.tex` (cvc5 `src/theory/pbv/rewrites-exp`): EXP rules, reducing instances, shift normalization, **generated** | 13 + 5 guard counterexamples |

The three `Rare*.lean` files are generated from the RARE files by
`scripts/rare_to_lean.py` (the same source as the `rr-*.tex` tables);
hand proofs live in `scripts/rare_lean_proofs.py`. Do not edit them by hand:
`python3 scripts/rare_to_lean.py` (from the paper root) regenerates and checks all three.
