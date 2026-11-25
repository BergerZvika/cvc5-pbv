/-
Shared semantics for the soundness proofs of the rewrite rules, lemma
schemas and learned rewrites of the EXP/PBV paper.

* Integers: Lean's `Int` `/` and `%` are Euclidean (`Int.ediv`/`Int.emod`),
  which is SMT-LIB `div`/`mod`. Division by zero is total: `x / 0 = 0` and
  `x % 0 = x`, matching cvc5's total semantics.
* `smtExp s t` is SMT-LIB `(** s t)`: `s^t` for `t ≥ 0`, `1 div s^(-t)` otherwise.
* Parametric bit-vectors are Lean's `BitVec w` with `w` universally quantified.
* `piand k x y` is the integer bitwise conjunction of `x` and `y` read as
  `k`-bit values.
-/
import Mathlib

namespace Pbv

/-- SMT-LIB integer exponentiation `**` (total, including negative exponents). -/
def smtExp (s t : Int) : Int :=
  if 0 ≤ t then s ^ t.toNat else 1 / s ^ (-t).toNat

@[simp] theorem smtExp_of_nonneg {s t : Int} (h : 0 ≤ t) : smtExp s t = s ^ t.toNat := by
  simp [smtExp, h]

theorem smtExp_of_neg {s t : Int} (h : t < 0) : smtExp s t = 1 / s ^ (-t).toNat := by
  simp [smtExp, not_le.mpr h]

@[simp] theorem smtExp_natCast (s : Int) (n : Nat) : smtExp s n = s ^ n := by
  simp [smtExp]

/-- `2^k` as produced by the translation of PBV widths. -/
abbrev pow2 (k : Int) : Int := smtExp 2 k

/-- Integer bitwise AND at width `k` (cvc5 `piand`/`iand`). Arguments are
reduced modulo `2^k` first, so the result always lies in `[0, 2^k)`. -/
def piand (k : Nat) (x y : Int) : Int :=
  ((x % 2 ^ k).toNat &&& (y % 2 ^ k).toNat : Nat)

/-- SMT-LIB semantics sanity checks: `div`/`mod` are Euclidean, division by
zero is total, and the negative-exponent cases of `**`. -/
example : (-7 : Int) / 2 = -4 ∧ (-7 : Int) % 2 = 1 := by decide
example : (7 : Int) / -2 = -3 ∧ (7 : Int) % -2 = 1 := by decide
example : (5 : Int) / 0 = 0 ∧ (5 : Int) % 0 = 5 := by decide
example : smtExp 0 0 = 1 ∧ smtExp 0 (-1) = 0 ∧ smtExp 2 (-1) = 0 ∧
    smtExp (-2) (-1) = 0 ∧ smtExp (-1) (-3) = -1 ∧ smtExp (-1) (-4) = 1 := by decide

end Pbv
