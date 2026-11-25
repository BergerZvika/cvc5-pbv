/-
Soundness of the new PIAND lemma schema (paper, Table `tab:lem-piand-new`,
Section "Reasoning about Parametric Bitwise Conjunction").

`piand k x y` (from `Defs`) is the conjunction of `x` and `y` read as `k`-bit
values. In cvc5 the width `k` is an integer term and `2^k` is `(** 2 k)`; for
`k < 0` that is `0`, so the range guard `0 ≤ x < 2^k` is unsatisfiable and
the lemma is vacuous (`complement_neg_width`). The substantive case is
`k : Nat`.
-/
import PbvProofs.Defs

namespace Pbv

open BitVec

/-- The bit-level core: `X & Y` and `X & ~Y` partition the bits of `X`. -/
theorem nat_and_add_and_compl (k X Y : Nat) (hX : X < 2 ^ k) (hY : Y < 2 ^ k) :
    (X &&& Y) + (X &&& (2 ^ k - 1 - Y)) = X := by
  let bx := BitVec.ofNat k X
  let byy := BitVec.ofNat k Y
  have hbx : bx.toNat = X := by simp [bx, Nat.mod_eq_of_lt hX]
  have hby : byy.toNat = Y := by simp [byy, Nat.mod_eq_of_lt hY]
  have hd : (bx &&& byy) &&& (bx &&& ~~~byy) = 0#k := by
    ext i hi; simp; cases bx[i] <;> cases byy[i] <;> simp
  have hs : (bx &&& byy) + (bx &&& ~~~byy) = bx := by
    rw [add_eq_or_of_and_eq_zero _ _ hd]
    ext i hi; simp; cases bx[i] <;> cases byy[i] <;> simp
  have h := congrArg BitVec.toNat hs
  rw [toNat_add_of_and_eq_zero hd, toNat_and, toNat_and, toNat_not, hbx, hby] at h
  exact h

/-- **complement** (new):
`(0 ≤ x < 2^k ∧ 0 ≤ y < 2^k) ⇒ piand(k,x,y) + piand(k,x,2^k-1-y) = x`. -/
theorem complement (k : Nat) (x y : Int) (hx0 : 0 ≤ x) (hx : x < 2 ^ k)
    (hy0 : 0 ≤ y) (hy : y < 2 ^ k) :
    piand k x y + piand k x (2 ^ k - 1 - y) = x := by
  lift x to Nat using hx0
  lift y to Nat using hy0
  have hX : x < 2 ^ k := by exact_mod_cast hx
  have hY : y < 2 ^ k := by exact_mod_cast hy
  have h1 : (x : Int) % 2 ^ k = x := Int.emod_eq_of_lt (by omega) hx
  have h2 : (y : Int) % 2 ^ k = y := Int.emod_eq_of_lt (by omega) hy
  have hc : ((2 : Int) ^ k - 1 - y) = ((2 ^ k - 1 - y : Nat) : Int) := by
    have : (1 : Nat) ≤ 2 ^ k := Nat.one_le_two_pow
    push_cast [Nat.cast_sub this, Nat.cast_sub (show y ≤ 2 ^ k - 1 by omega)]; ring
  have h3 : ((2 : Int) ^ k - 1 - y) % 2 ^ k = ((2 ^ k - 1 - y : Nat) : Int) := by
    rw [hc]; exact Int.emod_eq_of_lt (by omega) (by
      have : 2 ^ k - 1 - y < 2 ^ k := by omega
      exact_mod_cast this)
  unfold piand
  rw [h1, h2, h3]
  simp only [Int.toNat_natCast]
  exact_mod_cast nat_and_add_and_compl k x y hX hY

/-- The mirrored instance emitted by `--piand-lemmas=complement-sym`:
`(0 ≤ x < 2^k ∧ 0 ≤ y < 2^k) ⇒ piand(k,x,y) + piand(k,2^k-1-x,y) = y`. -/
theorem complement_sym (k : Nat) (x y : Int) (hx0 : 0 ≤ x) (hx : x < 2 ^ k)
    (hy0 : 0 ≤ y) (hy : y < 2 ^ k) :
    piand k x y + piand k (2 ^ k - 1 - x) y = y := by
  have hcomm : ∀ a b, piand k a b = piand k b a := fun a b => by
    unfold piand; rw [Nat.land_comm]
  rw [hcomm x y, hcomm (2 ^ k - 1 - x) y]
  exact complement k y x hy0 hy hx0 hx

/-- For a negative width the guard `0 ≤ x < 2^k` (with `2^k = (** 2 k) = 0`)
is unsatisfiable, so the lemma as emitted by cvc5 over an integer `k` is
vacuously true there. -/
theorem complement_neg_width (k : Int) (hk : k < 0) (x : Int) :
    ¬ (0 ≤ x ∧ x < smtExp 2 k) := by
  rw [smtExp_of_neg hk]
  have : (1 : Int) < 2 ^ (-k).toNat := by
    have : 0 < (-k).toNat := by omega
    exact_mod_cast Nat.one_lt_two_pow (by omega)
  rw [Int.ediv_eq_zero_of_lt (by norm_num) this]; omega

/-- The range guard is necessary: without it the split fails
(`k = 1`, `x = 2`, `y = 0`: `piand 1 2 0 + piand 1 2 1 = 0 ≠ 2`). -/
theorem complement_needs_range :
    ¬ ∀ (k : Nat) (x y : Int), piand k x y + piand k x (2 ^ k - 1 - y) = x := by
  intro h; have := h 1 2 0; revert this; decide

end Pbv
