# pow_proofs_nosmt — why are the exponents non-negative?

For every term `(** s t)` in a benchmark, this tool explains, **using only the
benchmark's own `assert`s**, why the exponent `t` is non-negative — or shows
that it is not. It does this **without calling an SMT solver**: everything
(parsing, bound reasoning, exact linear programming) is plain Python 3 with the
standard library only.

The motivation: `**` with a negative exponent has no single agreed meaning
(`2^-1` could be `2`, `0`, …). If every exponent is provably `>= 0` under the
assertions, the semantics of negative exponents cannot matter for that benchmark.

## Quick start

```bash
# from QF_EIA_CVC5/ (or anywhere — the script cds to the benchmark root)
pow_proofs_nosmt/run_pow_proofs_nosmt.sh              # -> pow_proofs_nosmt/results/
pow_proofs_nosmt/run_pow_proofs_nosmt.sh OUT_DIR      # other output dir
pow_proofs_nosmt/run_pow_proofs_nosmt.sh OUT_DIR --json   # also write .proof.json
```

Running on all 4664 LoAT + PURRS benchmarks takes about 1.5 minutes.

Single files / directories, printed to the terminal:

```bash
python3 pow_proofs_nosmt/explain_pow_nonneg_nosmt.py PURRS/purrs11.smt2
python3 pow_proofs_nosmt/explain_pow_nonneg_nosmt.py --summary PURRS     # one line per file
python3 pow_proofs_nosmt/explain_pow_nonneg_nosmt.py --json  FILE        # JSON to stdout
```

Requirements: `python3` (>= 3.8). Nothing to install.

## Files

| File | Purpose |
|---|---|
| `explain_pow_nonneg_nosmt.py` | the prover / explainer |
| `run_pow_proofs_nosmt.sh` | runs it on `LoAT` and `PURRS`, writes `results/` |
| `results/summary.txt` | totals + one status line per benchmark |
| `results/<benchmark>.proof.txt` | the explanation for that benchmark (same folder layout as the benchmarks) |
| `results/vacuous_files.txt` | benchmarks with a "proved (vacuous)" exponent |
| `results/vacuous_report.txt` | for each of those, the contradictory assertions |

## What the output looks like

```
=== LoAT/TPDB_ITS_Termination/MysteriousProgram.jar-obl-12.smt2_0.smt2
  1 distinct exponent(s), 1 proved non-negative

  t = it192
    used in pow0 := (** 2 it192)
  status: proved
    by bound propagation: t >= 1
  because of:
    [A8.10] (>= (+ it192 (- 1)) 0)
```

* `t = …` — the exponent as written; `= …` below it is its normalised polynomial.
* `used in powN := …` — the `**` terms with this exponent (each distinct `**`
  term is named `pow0`, `pow1`, …).
* `status` — see the table below; the next line says which method succeeded.
* `because of:` — the assertions the proof uses. `[A8.10]` means
  *the 10th conjunct of the 8th `assert`* in the file (`[A1]` when the assert is
  not a conjunction).

A counterexample looks like this (`PURRS/purrs01.smt2`, only assertion `n > 0`):

```
  t = (- n 2)
      = n - 2
    used in pow2 := (** 2 (- n 2))
  status: NOT IMPLIED
  counterexample (satisfies every linear assert over plain variables):
    n=1, t=-1
```

### Status values

| Status | Meaning |
|---|---|
| `proved` | `t >= 0` follows from the listed assertions, and these assertions are consistent |
| `proved (vacuous)` | the listed assertions **contradict each other**, so they imply anything, including `t >= 0` — this says nothing about the exponent |
| `NOT IMPLIED` | an integer assignment satisfies the linear assertions with `t < 0` (shown) |
| `NOT PROVED` | none of the methods succeeded and no counterexample was found (does not occur on LoAT/PURRS) |
| `NEGATIVE` | the exponent is a negative constant (does not occur on LoAT/PURRS) |

## How it works

### 1. Parsing and normalisation

1. The `.smt2` file is tokenised and parsed into s-expressions (own parser).
2. `let`s are expanded; every top-level `assert` is split into its `and`
   conjuncts, which are labelled `A<assert>.<conjunct>`.
3. Every distinct `(** s e)` term becomes an integer **atom** `powN`
   (it is not interpreted further, except by the rules in step 3 below).
4. Every *atomic* conjunct — a comparison `< <= > >= =`, possibly under `not` —
   is rewritten to the form `p >= 0` or `p = 0`, where `p` is a polynomial whose
   monomials are products of variables and `pow` atoms. Strict comparisons are
   turned into non-strict ones using integrality (`x > 0` ⇒ `x - 1 >= 0`).
5. **Integer tightening**: each constraint is divided by the gcd of its
   coefficients and the constant is rounded down
   (`2x + 2y - 1 >= 0` ⇒ `x + y - 1 >= 0`).

Conjuncts that are not atomic comparisons (`or`, `distinct`, `not (= …)`, …) and
comparisons containing `div`, `mod` or `/` are **ignored** — the tool never
reasons with them, so it never depends on them.

For each distinct exponent `t` the following steps are tried in order; the
first one that succeeds gives the explanation.

### 2. Constant exponent

`(** x 2)`: `t` is the numeral `2`, decided directly (`proved`, no assertions needed).

### 3. Bound propagation + interval evaluation

All constraints are used to derive lower/upper bounds for every atom, by
repeatedly solving each constraint for each of its atoms
(e.g. from `n - 3 >= 0` derive `n >= 3`; from `a - b >= 0` and `b >= 1`
derive `a >= 1`). Bounds are rounded to integers, and non-linear monomials get
bounds from the product of their factors' bounds. Every bound remembers the set
of assertions it was derived from. Propagation runs at most 30 rounds and stops
at the first contradiction (lower bound > upper bound); bounds derived before
that point are still valid consequences of the assertions.

Then `t` itself is evaluated over these bounds (interval arithmetic):

* `+`, `-`, `*` — the usual interval rules; a repeated factor is a power, so
  `(* n n) >= 0` is known without any assertion;
* `(div a k)` with a numeral `k > 0` — `floor(lo/k) … floor(hi/k)`;
* `abs`, `ite` — the obvious hull;
* `(** s k)` with a numeral `k >= 0` — the interval of `s^k`;
* `(** b e)` with a numeral `b > 0` — `>= 1` if `e` is itself shown `>= 0`
  (this handles nested powers such as `(** 2 (** 4 x))`).

If the lower bound of `t` is `>= 0`, the exponent is `proved`
(“by bound propagation: t >= L”), and the assertions behind the bounds used are
the explanation. This step proves 9,372 of the 11,697 exponents.

### 4. Linear combination (Farkas certificate)

When bounds are not enough (e.g. `t = x - y` with the assertion `x >= y`), the
tool looks for non-negative multipliers `λᵢ` for inequalities (and arbitrary
multipliers for equalities) such that

```
t  =  Σ λᵢ · eᵢ  +  d       with   eᵢ >= 0 the constraints,  λᵢ >= 0,  d > -1
```

Then `t >= d > -1`, and since `t` is an integer, `t >= 0`. Finding the `λᵢ` is
a linear program; it is solved with an **exact rational simplex**
(`fractions.Fraction`, Bland's rule — no floating point, no rounding errors).
Only the constraints connected to `t`'s variables through shared variables are
included (at most 400). The constraints with `λᵢ ≠ 0` form the explanation
(“by linear combination of the asserts (Farkas)”).

### 5. Vacuity check

After a proof is found, the tool checks whether **the assertions it used**
are already contradictory on their own — by bound propagation over just those
assertions, and by searching for a Farkas certificate of `0 >= 1`
(`Σ λᵢ · eᵢ = -1` with all variables cancelling). If they are, the status
becomes `proved (vacuous)` and the explanation lists the contradictory set
instead. If no proof was found at all but the assertions are contradictory,
the result is also `proved (vacuous)`.

### 6. Counterexample search

If nothing worked, and the linear assertions mention at most 4 plain variables,
all integer points in `[-10, 10]^k` are tried. A point satisfying every linear
assertion over plain variables with `t < 0` is reported (`NOT IMPLIED`).
Assertions involving `pow` atoms or non-linear terms are not checked, which the
output says (“satisfies every linear assert over plain variables”).

## Results on LoAT + PURRS

```
4664 files; exponents: proved=11649, proved (vacuous)=48, NOT IMPLIED=2
```

* **proved 11,649** — 2,140 constant exponents, 9,372 by bound propagation,
  137 by Farkas certificates.
* **proved (vacuous) 48** — all in LoAT; listed with their contradictory
  assertions in `results/vacuous_report.txt`.
* **NOT IMPLIED 2** — `PURRS/purrs01.smt2` and `PURRS/purrs23.smt2`: the only
  assertion is `n > 0`, so the exponent `n - 2` can be `-1`. This does **not**
  make the benchmarks depend on the semantics of negative exponents — see below.

### Why `purrs01` and `purrs23` still don't depend on negative exponents

Two solvers with different meanings for a negative exponent — one using
`exp(s, t) = exp(s, -t)`, the other `exp(s, t) = 1 div exp(s, -t)` when `t < 0` —
both answer `unsat` on these two files, and never disagree. The reason: the
negative exponent happens at only one value of `n`, and there the `**` term is
multiplied by `0`. So the choice of meaning for negative exponents never affects
the result.

**Where the exponent goes negative.** Both files assert only `(> n 0)`. The
exponent `n-2` (written `(- n 2)` in purrs01 and `(- (- n 1) 1)` in purrs23) is
negative only at `n = 1`, where it is `-1`. Every other exponent (`n` and `n-1`)
is `>= 0` for all `n > 0`.

**At `n = 1` that term's value doesn't count.** In both files it appears only as
a product with `(n-1)`:

- purrs01: `(* (- n 1) (** 2 (- n 2)))`
- purrs23: `(* (- n 1) (** 2 (- (- n 1) 1)))`

At `n = 1` this is `0 * 2^(-1)`, which is `0` whatever `2^(-1)` means:

| Meaning of a negative exponent | `2^(-1)` | `(n-1) * 2^(-1)` at `n = 1` |
|---|---|---|
| `2^t = 2^(-t)` | 2 | 0 |
| `2^t = 1 div 2^(-t)` | 0 | 0 |

For `n >= 2` every exponent is `>= 0`, so both solvers read the formula the
same way, and the recurrence identity each benchmark encodes holds, giving
`unsat`.

The `NOT IMPLIED` status is still correct — the assertions do not force
`n - 2 >= 0` — but this tool only checks whether each exponent is forced to be
`>= 0`; it does not check whether a negative exponent can affect the formula's
value, so it can flag files like these even though the result is the same
under every meaning of negative exponents.

### Validation

Every one of the 9,557 non-constant proofs was re-checked with
z3 (z3 is used only for this check, not by the tool): in all cases the listed
assertions together with `t < 0` are unsatisfiable (the proof is sound), all
9,509 `proved` explanations use satisfiable assertion sets, and all 48
`proved (vacuous)` ones use unsatisfiable sets. The results are deterministic:
two full runs with different Python hash seeds produce identical output.
