/-
Soundness of the reduction of redundant `mod`/`div` operations on the
translated integer formula (paper Table `tab:mod-reduce`), implemented in
`src/preprocessing/passes/pbv_mod_reducer.cpp`.

Widths are integer terms, and `2^k` is `smtExp 2 k`, which is `0` for `k < 0`;
then `x mod 2^k = x mod 0 = x`. This is why the side conditions of the paper
carry sign guards; each such guard is shown necessary by an `_unguarded_unsound`
counterexample next to the proved rule.
-/
import PbvProofs.Defs

namespace Pbv

theorem pow2_of_nonneg {k : Int} (hk : 0 ≤ k) : pow2 k = 2 ^ k.toNat := smtExp_of_nonneg hk

theorem pow2_pos {k : Int} (hk : 0 ≤ k) : 0 < pow2 k := by
  rw [pow2_of_nonneg hk]; positivity

theorem pow2_neg {k : Int} (hk : k < 0) : pow2 k = 0 := by
  rw [pow2, smtExp_of_neg hk]
  have hn : 1 ≤ (-k).toNat := by omega
  exact Int.ediv_eq_zero_of_lt (by norm_num)
    (by calc (1 : Int) < 2 ^ 1 := by norm_num
          _ ≤ 2 ^ (-k).toNat := pow_le_pow_right₀ (by norm_num) hn)

theorem pow2_add {a b : Int} (ha : 0 ≤ a) (hb : 0 ≤ b) : pow2 (a + b) = pow2 a * pow2 b := by
  rw [pow2_of_nonneg (by omega), pow2_of_nonneg ha, pow2_of_nonneg hb, Int.toNat_add ha hb,
    pow_add]

theorem pow2_dvd_pow2 {k m : Int} (hk : 0 ≤ k) (hkm : k ≤ m) : pow2 k ∣ pow2 m := by
  rw [pow2_of_nonneg hk, pow2_of_nonneg (by omega)]
  exact pow_dvd_pow 2 (by omega)

/-! ## div-div, div-zero (parabit axioms; cvc5 cases 11, 13) -/

/-- **div-div** (cav26): `(x div 2^i) div 2^j → x div 2^(i+j)` when `i, j ≥ 0`.
cvc5: case 11, `pbv_mod_reducer.cpp:607-612` checks both `nonNeg`. -/
theorem div_div (x i j : Int) (hi : 0 ≤ i) (hj : 0 ≤ j) :
    x / pow2 i / pow2 j = x / pow2 (i + j) := by
  rw [pow2_add hi hj, Int.ediv_ediv_of_nonneg (pow2_pos hi).le]

/-- The guard of **div-div** is needed: `i = -1, j = 1, x = 2`. -/
theorem div_div_needs_guard :
    ¬ ∀ x i j : Int, x / pow2 i / pow2 j = x / pow2 (i + j) := by
  intro h; have := h 2 (-1) 1; revert this; decide

/-- **div-zero** without the guard `0 ≤ x` — `x div 2^j → 0` when `x < 2^m, m ≤ j` —
is unsound for negative `x`: `x = -1, m = j = 0` gives `-1 div 1 = -1`. -/
theorem div_zero_unguarded_unsound :
    ¬ ∀ x m j : Int, x < pow2 m → m ≤ j → x / pow2 j = 0 := by
  intro h; have := h (-1) 0 0 (by decide) le_rfl; revert this; decide

/-- **div-zero** as in the paper: `0 ≤ x < 2^m`, `m ≤ j`. cvc5 (case 13,
`pbv_mod_reducer.cpp:619-626`) takes `m` from `widthOf(x)`, whose non-null
result certifies `0 ≤ x < 2^m` (`pbv_mod_reducer.cpp:102`), so the code is sound. -/
theorem div_zero (x m j : Int) (hx : 0 ≤ x) (hxm : x < pow2 m) (hmj : m ≤ j) :
    x / pow2 j = 0 := by
  by_cases hm : 0 ≤ m
  · apply Int.ediv_eq_zero_of_lt hx
    calc x < pow2 m := hxm
      _ ≤ pow2 j := by
        rw [pow2_of_nonneg hm, pow2_of_nonneg (by omega)]
        exact pow_le_pow_right₀ (by norm_num) (by omega)
  · rw [pow2_neg (by omega)] at hxm; omega

/-! ## Nested and distributed `mod` (cvc5 cases 1–5) -/

/-- **mod-mod-outer** without the guard `0 ≤ k` — `(x mod 2^m) mod 2^k → x mod 2^k` when
`k ≤ m` — is unsound for `k < 0`: `x = 1, m = 0, k = -1`. -/
theorem mod_mod_outer_unguarded_unsound :
    ¬ ∀ x m k : Int, k ≤ m → x % pow2 m % pow2 k = x % pow2 k := by
  intro h; have := h 1 0 (-1) (by decide); revert this; decide

/-- **mod-mod-outer** as in the paper: `0 ≤ k ≤ m`.
cvc5: case 1, guarded by `nonNeg(k)` at `pbv_mod_reducer.cpp:356`. -/
theorem mod_mod_outer (x m k : Int) (hk : 0 ≤ k) (hkm : k ≤ m) :
    x % pow2 m % pow2 k = x % pow2 k :=
  Int.emod_emod_of_dvd x (pow2_dvd_pow2 hk hkm)

/-- **mod-mod-inner** without the guard `0 ≤ m` — `(x mod 2^m) mod 2^k → x mod 2^m` when
`m ≤ k` — is unsound for `m < 0`: `x = 5, m = -1, k = 0`. -/
theorem mod_mod_inner_unguarded_unsound :
    ¬ ∀ x m k : Int, m ≤ k → x % pow2 m % pow2 k = x % pow2 m := by
  intro h; have := h 5 (-1) 0 (by decide); revert this; decide

/-- **mod-mod-inner** as in the paper: `0 ≤ m ≤ k`.
cvc5: case 2, guarded by `nonNeg(m)` at `pbv_mod_reducer.cpp:379`. -/
theorem mod_mod_inner (x m k : Int) (hm : 0 ≤ m) (hmk : m ≤ k) :
    x % pow2 m % pow2 k = x % pow2 m := by
  have hpm := pow2_pos hm
  apply Int.emod_eq_of_lt (Int.emod_nonneg _ hpm.ne')
  calc x % pow2 m < pow2 m := Int.emod_lt_of_pos _ hpm
    _ ≤ pow2 k := by
      rw [pow2_of_nonneg hm, pow2_of_nonneg (by omega)]
      exact pow_le_pow_right₀ (by norm_num) (by omega)

/-- **mod-arith** without the guard `0 ≤ k` is unsound for `k < 0` (`f = +`, `x = 1, y = 0, m = 0, k = -1`). -/
theorem mod_arith_unguarded_unsound :
    ¬ ∀ x y m k : Int, k ≤ m → (x % pow2 m + y) % pow2 k = (x + y) % pow2 k := by
  intro h; have := h 1 0 0 (-1) (by decide); revert this; decide

/-- **mod-arith** (cav26) as in the paper (`0 ≤ k ≤ m`), for `f = +`, both argument positions.
cvc5: case 3, under the same `nonNeg(k)` guard (`pbv_mod_reducer.cpp:356`). -/
theorem mod_arith_add (x y m k : Int) (hk : 0 ≤ k) (hkm : k ≤ m) :
    (x % pow2 m + y) % pow2 k = (x + y) % pow2 k ∧
    (y + x % pow2 m) % pow2 k = (y + x) % pow2 k := by
  have h := mod_mod_outer x m k hk hkm
  constructor
  · rw [Int.add_emod, h, ← Int.add_emod]
  · rw [Int.add_emod, h, ← Int.add_emod]

/-- **mod-arith** for `f = -` (both positions) and unary negation. -/
theorem mod_arith_sub (x y m k : Int) (hk : 0 ≤ k) (hkm : k ≤ m) :
    (x % pow2 m - y) % pow2 k = (x - y) % pow2 k ∧
    (y - x % pow2 m) % pow2 k = (y - x) % pow2 k ∧
    (-(x % pow2 m)) % pow2 k = (-x) % pow2 k := by
  have h := mod_mod_outer x m k hk hkm
  refine ⟨?_, ?_, ?_⟩
  · rw [Int.sub_emod, h, ← Int.sub_emod]
  · rw [Int.sub_emod, h, ← Int.sub_emod]
  · rw [show -(x % pow2 m) = 0 - x % pow2 m by ring, show -x = 0 - x by ring,
      Int.sub_emod, h, ← Int.sub_emod]

/-- **mod-arith** for `f = ·` (both positions). -/
theorem mod_arith_mul (x y m k : Int) (hk : 0 ≤ k) (hkm : k ≤ m) :
    (x % pow2 m * y) % pow2 k = (x * y) % pow2 k ∧
    (y * (x % pow2 m)) % pow2 k = (y * x) % pow2 k := by
  have h := mod_mod_outer x m k hk hkm
  constructor
  · rw [Int.mul_emod, h, ← Int.mul_emod]
  · rw [Int.mul_emod, h, ← Int.mul_emod]

/-- **mod-div** without the guard `0 ≤ w` — `((x mod 2^m) div 2^j) mod 2^w → (x div 2^j) mod 2^w`
when `j + w ≤ m` — is unsound for `w < 0`: `x = 1, j = 0, w = -1, m = 0`. -/
theorem mod_div_unguarded_unsound :
    ¬ ∀ x m j w : Int, j + w ≤ m → x % pow2 m / pow2 j % pow2 w = x / pow2 j % pow2 w := by
  intro h; have := h 1 0 0 (-1) (by decide); revert this; decide

/-- **mod-div** (cav26) as in the paper: `0 ≤ w` and `j + w ≤ m` (the guard `j ≥ 0`
is not needed: for `j < 0` both sides are `0 mod 2^w`).
cvc5: case 5 checks `nonNeg(j)` (`pbv_mod_reducer.cpp:688`) and `nonNeg(k)`
(the outer width `w`, line 356) — sufficient. -/
theorem mod_div (x m j w : Int) (hw : 0 ≤ w) (hjwm : j + w ≤ m) :
    x % pow2 m / pow2 j % pow2 w = x / pow2 j % pow2 w := by
  by_cases hj : 0 ≤ j
  · have hm : 0 ≤ m := by omega
    -- x mod 2^m = x - 2^m * q, and 2^m = 2^j * 2^(m-j)
    have hsplit : pow2 m = pow2 j * pow2 (m - j) := by
      rw [← pow2_add hj (by omega)]; congr 1; omega
    have hx : x % pow2 m = x + pow2 j * (-(pow2 (m - j) * (x / pow2 m))) := by
      have := Int.mul_ediv_add_emod x (pow2 m)
      rw [hsplit] at this ⊢; linarith
    rw [hx, Int.add_mul_ediv_left _ _ (pow2_pos hj).ne']
    have hd : pow2 w ∣ pow2 (m - j) := pow2_dvd_pow2 hw (by omega)
    obtain ⟨d, hd⟩ := hd
    rw [hd, show x / pow2 j + -(pow2 w * d * (x / pow2 m)) =
        x / pow2 j + pow2 w * (-(d * (x / pow2 m))) by ring, Int.add_mul_emod_self_left]
  · rw [pow2_neg (k := j) (by omega)]; simp

/-- **mod-ite** without the guard `0 ≤ k` is unsound for `k < 0`. -/
theorem mod_ite_unguarded_unsound :
    ¬ ∀ (c : Bool) (x y m₁ m₂ k : Int), k ≤ m₁ → k ≤ m₂ →
      (if c then x % pow2 m₁ else y % pow2 m₂) % pow2 k = (if c then x else y) % pow2 k := by
  intro h; have := h true 1 0 0 0 (-1) (by decide) (by decide); revert this; decide

/-- **mod-ite** (new) as in the paper: `0 ≤ k`, `k ≤ m₁`, `k ≤ m₂`.
cvc5: case 4, under the `nonNeg(k)` guard (`pbv_mod_reducer.cpp:356`). -/
theorem mod_ite (c : Prop) [Decidable c] (x y m₁ m₂ k : Int) (hk : 0 ≤ k)
    (h₁ : k ≤ m₁) (h₂ : k ≤ m₂) :
    (if c then x % pow2 m₁ else y % pow2 m₂) % pow2 k = (if c then x else y) % pow2 k := by
  split_ifs
  · exact mod_mod_outer x m₁ k hk h₁
  · exact mod_mod_outer y m₂ k hk h₂

end Pbv
