/-
Soundness of the learned rewrite rules on PBV terms
(paper Table `tab:mw-learned`, implemented in
`cvc5/src/preprocessing/passes/learned_rewrite_pbv.cpp`).

Modelling conventions:
* a parametric bit-vector of width `w` is a Lean `BitVec w`, with `w`
  universally quantified;
* the low extract `t[i:0]` is `t.setWidth (i+1)` (equal to
  `extractLsb' 0 (i+1) t` whenever `i+1 ≤ |t|`, which the run-time type
  constraints assert);
* `sign_extend(n, x)` / `zero_extend(n, x)` of a `p`-bit `x` is
  `x.signExtend (p+n)` / `x.setWidth (p+n)`;
* side conditions of the form `|x| = i+1` are expressed by the type of `x`.
-/
import PbvProofs.Defs

namespace Pbv
open BitVec

/-! ## Helpers -/

theorem setWidth_sub' {w i : Nat} (x y : BitVec w) (h : i ≤ w) :
    (x - y).setWidth i = x.setWidth i - y.setWidth i := by
  have := BitVec.setWidth_add (x - y) y h
  rw [BitVec.sub_add_cancel] at this
  rw [this, BitVec.add_sub_cancel]

/-- Truncation distributes over the five operators that `isPushOp` lists. -/
theorem setWidth_or' {w i : Nat} (x y : BitVec w) :
    (x ||| y).setWidth i = x.setWidth i ||| y.setWidth i := BitVec.setWidth_or

theorem setWidth_xor' {w i : Nat} (x y : BitVec w) :
    (x ^^^ y).setWidth i = x.setWidth i ^^^ y.setWidth i := BitVec.setWidth_xor

theorem setWidth_signExtend_low {p v k : Nat} (x : BitVec p) (hk : k ≤ p) (hv : p ≤ v) :
    (x.signExtend v).setWidth k = x.setWidth k := by
  apply BitVec.eq_of_getLsbD_eq; intro j hj
  simp only [getLsbD_setWidth, getLsbD_signExtend]
  by_cases h : j < k
  · have : j < p := by omega
    have : j < v := by omega
    simp [*]
  · simp [h]

theorem setWidth_zeroExtend_low {p v k : Nat} (x : BitVec p) (hv : k ≤ v) :
    (x.setWidth v).setWidth k = x.setWidth k :=
  BitVec.setWidth_setWidth_of_le x hv

theorem signExtend_one_one (n : Nat) : (1#1).signExtend (1 + n) = allOnes (1 + n) := by
  apply BitVec.eq_of_getLsbD_eq; intro j hj
  simp only [getLsbD_signExtend, getLsbD_allOnes]
  by_cases h : j < 1
  · have : j = 0 := by omega
    subst this; simp
  · simp [h, hj, BitVec.msb]

theorem signExtend_zero_one (n : Nat) : (0#1).signExtend (1 + n) = 0#(1 + n) := by
  apply BitVec.eq_of_getLsbD_eq; intro j hj
  simp [getLsbD_signExtend, BitVec.msb]

theorem bv1_cases (c : BitVec 1) : c = 0#1 ∨ c = 1#1 := by
  revert c; decide

/-- `msb` of a zero extension by at least one bit is `0`. -/
theorem msb_setWidth_of_lt {p W : Nat} (x : BitVec p) (h : p < W) :
    (x.setWidth W).msb = false := by
  rw [msb_setWidth]
  simp [BitVec.getLsbD_of_ge x (W - 1) (by omega)]

/-! ## shl-ashr  (code: I3, `lrSextIdioms`) -/

/-- **shl-ashr** [cav26]:
`(x << z) >>ₐ z → sign_extend(m, x[|x|-m-1:0])`, `z = int_to_pbv(|x|, m)`,
side condition `0 ≤ m < |x|`. -/
theorem shl_ashr {w m : Nat} (x : BitVec w) (hm : m < w) :
    (x <<< (BitVec.ofNat w m)).sshiftRight' (BitVec.ofNat w m)
      = (x.setWidth (w - m)).signExtend w := by
  have hmw : m % 2 ^ w = m := Nat.mod_eq_of_lt (Nat.lt_trans hm (Nat.lt_two_pow_self))
  rw [sshiftRight_eq', shiftLeft_eq', toNat_ofNat, hmw]
  apply BitVec.eq_of_getLsbD_eq; intro j hj
  simp only [getLsbD_sshiftRight, getLsbD_signExtend, getLsbD_setWidth,
    msb_eq_getLsbD_last, getLsbD_shiftLeft]
  by_cases h1 : m + j < w
  · have : j < w - m := by omega
    simp [h1, this, hj, show ¬ (w ≤ j) by omega, show ¬ (m + j < m) by omega,
      show m + j - m = j by omega]
  · have : ¬ j < w - m := by omega
    simp [h1, this, hj, show ¬ (w ≤ j) by omega, show w - 1 < w by omega,
      show ¬ (w - 1 < m) by omega, show w - m - 1 < w - m by omega,
      show w - 1 - m = w - m - 1 by omega]

/-! ## lshr-shl-add  (code: F, `lrRules`)

Paper: `((x << z) + y) >> z → x + (y >> z)` with side condition
`s ≥ p + 2^u ∧ s > q`, where `x`, `y` and `z` are a `p`-bit, a `q`-bit and a
`u`-bit value, zero-extended to the width `s` of the shift. The side
condition `s ≥ p + 2^u - 1` of \[cav26\] is unsound. -/

/-- The side condition `s ≥ p + 2^u - 1` of \[cav26\] is **unsound**:
`s = 2, p = 1, u = 1, x = 1, z = 1, y = 2` gives LHS `0`, RHS `2`. -/
theorem lshr_shl_add_cav26_unsound :
    ¬ ∀ (s p u : Nat) (x : BitVec p) (z : BitVec u) (y : BitVec s),
        p + 2 ^ u - 1 ≤ s →
        ((x.setWidth s <<< z.setWidth s) + y) >>> z.setWidth s
          = x.setWidth s + (y >>> z.setWidth s) := by
  intro h
  have := h 2 1 1 1#1 1#1 2#2 (by decide)
  revert this; decide

/-- Still unsound when `y` is narrower than `s` (here `y` is a zero-extended
2-bit value at `s = 3 = p + 2^u - 1`): `x = 3, z = 1, y = 2` gives `0` vs `4`. -/
theorem lshr_shl_add_cav26_unsound_narrow_y :
    ¬ ∀ (s p u q : Nat) (x : BitVec p) (z : BitVec u) (y : BitVec q),
        p + 2 ^ u - 1 ≤ s → q + 1 ≤ s →
        ((x.setWidth s <<< z.setWidth s) + y.setWidth s) >>> z.setWidth s
          = x.setWidth s + (y.setWidth s >>> z.setWidth s) := by
  intro h
  have := h 3 2 1 2 3#2 1#1 2#2 (by decide) (by decide)
  revert this; decide

/-- `s ≥ p + 2^u` alone is not enough either when `y` has full width `s`:
`s = 3, p = 1, u = 1, x = 1, z = 1, y = 6` gives `0` vs `4`. -/
theorem lshr_shl_add_full_width_y_unsound :
    ¬ ∀ (s p u : Nat) (x : BitVec p) (z : BitVec u) (y : BitVec s),
        p + 2 ^ u ≤ s →
        ((x.setWidth s <<< z.setWidth s) + y) >>> z.setWidth s
          = x.setWidth s + (y >>> z.setWidth s) := by
  intro h
  have := h 3 1 1 1#1 1#1 6#3 (by decide)
  revert this; decide

/-- The exact semantic condition: the rule holds whenever neither the shift
nor the addition wraps, i.e. `x·2^z + y < 2^s`. -/
theorem lshr_shl_add_of_no_wrap {s : Nat} (x z y : BitVec s)
    (h : x.toNat * 2 ^ z.toNat + y.toNat < 2 ^ s) :
    ((x <<< z) + y) >>> z = x + (y >>> z) := by
  have hpos : 0 < 2 ^ z.toNat := Nat.two_pow_pos _
  have hsh : x.toNat * 2 ^ z.toNat < 2 ^ s := by omega
  apply BitVec.eq_of_toNat_eq
  rw [ushiftRight_eq', ushiftRight_eq', shiftLeft_eq', toNat_ushiftRight, toNat_add,
    toNat_add, toNat_ushiftRight, toNat_shiftLeft, Nat.shiftLeft_eq,
    Nat.mod_eq_of_lt hsh, Nat.mod_eq_of_lt h, Nat.shiftRight_eq_div_pow,
    Nat.shiftRight_eq_div_pow, Nat.mul_comm, Nat.add_comm, Nat.add_mul_div_left _ _ hpos]
  have h1 : y.toNat / 2 ^ z.toNat ≤ y.toNat := Nat.div_le_self _ _
  have h2 : x.toNat ≤ x.toNat * 2 ^ z.toNat := Nat.le_mul_of_pos_right _ hpos
  rw [Nat.mod_eq_of_lt (by omega), Nat.add_comm]

/-- **lshr-shl-add** as in the paper:
`((x << z) + y) >> z → x + (y >> z)` for a `p`-bit `x`, a `u`-bit `z` and a
`q`-bit `y`, all zero-extended to width `s`, under
`s ≥ p + 2^u` **and** `s > q` (`q + 1 ≤ s`). Both conjuncts are needed
(`lshr_shl_add_cav26_unsound_narrow_y`, `lshr_shl_add_full_width_y_unsound`). -/
theorem lshr_shl_add {s p u q : Nat} (x : BitVec p) (z : BitVec u) (y : BitVec q)
    (hx : p + 2 ^ u ≤ s) (hy : q + 1 ≤ s) :
    ((x.setWidth s <<< z.setWidth s) + y.setWidth s) >>> z.setWidth s
      = x.setWidth s + (y.setWidth s >>> z.setWidth s) := by
  apply lshr_shl_add_of_no_wrap
  have hu : u < 2 ^ u := Nat.lt_two_pow_self
  rw [toNat_setWidth_of_le (by omega), toNat_setWidth_of_le (by omega),
    toNat_setWidth_of_le (by omega)]
  have hxl : x.toNat < 2 ^ p := x.isLt
  have hyl : y.toNat < 2 ^ q := y.isLt
  have hzl : z.toNat ≤ 2 ^ u - 1 := by have := z.isLt; omega
  have e1 : x.toNat * 2 ^ z.toNat < 2 ^ (s - 1) := by
    calc x.toNat * 2 ^ z.toNat < 2 ^ p * 2 ^ z.toNat :=
          Nat.mul_lt_mul_of_pos_right hxl (Nat.two_pow_pos _)
      _ = 2 ^ (p + z.toNat) := (Nat.pow_add _ _ _).symm
      _ ≤ 2 ^ (s - 1) := Nat.pow_le_pow_right (by decide) (by omega)
  have e2 : y.toNat < 2 ^ (s - 1) :=
    Nat.lt_of_lt_of_le hyl (Nat.pow_le_pow_right (by decide) (by omega))
  have e3 : 2 ^ s = 2 ^ (s - 1) + 2 ^ (s - 1) := by
    rw [← Nat.two_mul, ← Nat.pow_succ']; congr 1; omega
  omega

/-- The code also matches the addition with its operands swapped. -/
theorem lshr_shl_add_comm {s p u q : Nat} (x : BitVec p) (z : BitVec u) (y : BitVec q)
    (hx : p + 2 ^ u ≤ s) (hy : q + 1 ≤ s) :
    (y.setWidth s + (x.setWidth s <<< z.setWidth s)) >>> z.setWidth s
      = x.setWidth s + (y.setWidth s >>> z.setWidth s) := by
  rw [BitVec.add_comm]; exact lshr_shl_add x z y hx hy

/-! ## extract-sext / extract-zext  (code: A1/A2) -/

/-- **extract-sext** [cav26]: `sign_extend(n, x)[i:0] → x`, side condition `|x| = i + 1`. -/
theorem extract_sext {i n : Nat} (x : BitVec (i + 1)) :
    (x.signExtend (i + 1 + n)).setWidth (i + 1) = x := by
  rw [setWidth_signExtend_low x (Nat.le_refl _) (by omega), setWidth_eq]

/-- **extract-zext** [cav26]: `zero_extend(n, x)[i:0] → x`, side condition `|x| = i + 1`. -/
theorem extract_zext {i n : Nat} (x : BitVec (i + 1)) :
    (x.setWidth (i + 1 + n)).setWidth (i + 1) = x := by
  rw [setWidth_zeroExtend_low x (by omega), setWidth_eq]

/-! ## extract-sext-op  (code: B1/B2, `isPushOp` = or xor add sub mul) -/

/-- **extract-sext-op** (|||) [cav26]:
`(sext(n, x) ||| y)[i:0] → x ||| y[i:0]`, side condition `|x| = i + 1`. -/
theorem extract_sext_or {i n : Nat} (x : BitVec (i + 1)) (y : BitVec (i + 1 + n)) :
    ((x.signExtend (i + 1 + n)) ||| y).setWidth (i + 1) = x ||| y.setWidth (i + 1) := by
  rw [setWidth_or', extract_sext]

/-- **extract-sext-op** (|||), extension on the right (code B2). -/
theorem extract_sext_or_right {i n : Nat} (x : BitVec (i + 1)) (y : BitVec (i + 1 + n)) :
    (y ||| (x.signExtend (i + 1 + n))).setWidth (i + 1) = y.setWidth (i + 1) ||| x := by
  rw [setWidth_or', extract_sext]

/-- **extract-sext-op** (^^^) [cav26]:
`(sext(n, x) ^^^ y)[i:0] → x ^^^ y[i:0]`, side condition `|x| = i + 1`. -/
theorem extract_sext_xor {i n : Nat} (x : BitVec (i + 1)) (y : BitVec (i + 1 + n)) :
    ((x.signExtend (i + 1 + n)) ^^^ y).setWidth (i + 1) = x ^^^ y.setWidth (i + 1) := by
  rw [setWidth_xor', extract_sext]

/-- **extract-sext-op** (^^^), extension on the right (code B2). -/
theorem extract_sext_xor_right {i n : Nat} (x : BitVec (i + 1)) (y : BitVec (i + 1 + n)) :
    (y ^^^ (x.signExtend (i + 1 + n))).setWidth (i + 1) = y.setWidth (i + 1) ^^^ x := by
  rw [setWidth_xor', extract_sext]

/-- **extract-sext-op** (+) [cav26]:
`(sext(n, x) + y)[i:0] → x + y[i:0]`, side condition `|x| = i + 1`. -/
theorem extract_sext_add {i n : Nat} (x : BitVec (i + 1)) (y : BitVec (i + 1 + n)) :
    ((x.signExtend (i + 1 + n)) + y).setWidth (i + 1) = x + y.setWidth (i + 1) := by
  rw [BitVec.setWidth_add _ _ (by omega), extract_sext]

/-- **extract-sext-op** (+), extension on the right (code B2). -/
theorem extract_sext_add_right {i n : Nat} (x : BitVec (i + 1)) (y : BitVec (i + 1 + n)) :
    (y + (x.signExtend (i + 1 + n))).setWidth (i + 1) = y.setWidth (i + 1) + x := by
  rw [BitVec.setWidth_add _ _ (by omega), extract_sext]

/-- **extract-sext-op** (-) [cav26]:
`(sext(n, x) - y)[i:0] → x - y[i:0]`, side condition `|x| = i + 1`. -/
theorem extract_sext_sub {i n : Nat} (x : BitVec (i + 1)) (y : BitVec (i + 1 + n)) :
    ((x.signExtend (i + 1 + n)) - y).setWidth (i + 1) = x - y.setWidth (i + 1) := by
  rw [setWidth_sub' _ _ (by omega), extract_sext]

/-- **extract-sext-op** (-), extension on the right (code B2). -/
theorem extract_sext_sub_right {i n : Nat} (x : BitVec (i + 1)) (y : BitVec (i + 1 + n)) :
    (y - (x.signExtend (i + 1 + n))).setWidth (i + 1) = y.setWidth (i + 1) - x := by
  rw [setWidth_sub' _ _ (by omega), extract_sext]

/-- **extract-sext-op** (*) [cav26]:
`(sext(n, x) * y)[i:0] → x * y[i:0]`, side condition `|x| = i + 1`. -/
theorem extract_sext_mul {i n : Nat} (x : BitVec (i + 1)) (y : BitVec (i + 1 + n)) :
    ((x.signExtend (i + 1 + n)) * y).setWidth (i + 1) = x * y.setWidth (i + 1) := by
  rw [BitVec.setWidth_mul _ _ (by omega), extract_sext]

/-- **extract-sext-op** (*), extension on the right (code B2). -/
theorem extract_sext_mul_right {i n : Nat} (x : BitVec (i + 1)) (y : BitVec (i + 1 + n)) :
    (y * (x.signExtend (i + 1 + n))).setWidth (i + 1) = y.setWidth (i + 1) * x := by
  rw [BitVec.setWidth_mul _ _ (by omega), extract_sext]

/-! ## extract-zext-op  (code: B1/B2, `isPushOp` = or xor add sub mul) -/

/-- **extract-zext-op** (|||) [cav26]:
`(zext(n, x) ||| y)[i:0] → x ||| y[i:0]`, side condition `|x| = i + 1`. -/
theorem extract_zext_or {i n : Nat} (x : BitVec (i + 1)) (y : BitVec (i + 1 + n)) :
    ((x.setWidth (i + 1 + n)) ||| y).setWidth (i + 1) = x ||| y.setWidth (i + 1) := by
  rw [setWidth_or', extract_zext]

/-- **extract-zext-op** (|||), extension on the right (code B2). -/
theorem extract_zext_or_right {i n : Nat} (x : BitVec (i + 1)) (y : BitVec (i + 1 + n)) :
    (y ||| (x.setWidth (i + 1 + n))).setWidth (i + 1) = y.setWidth (i + 1) ||| x := by
  rw [setWidth_or', extract_zext]

/-- **extract-zext-op** (^^^) [cav26]:
`(zext(n, x) ^^^ y)[i:0] → x ^^^ y[i:0]`, side condition `|x| = i + 1`. -/
theorem extract_zext_xor {i n : Nat} (x : BitVec (i + 1)) (y : BitVec (i + 1 + n)) :
    ((x.setWidth (i + 1 + n)) ^^^ y).setWidth (i + 1) = x ^^^ y.setWidth (i + 1) := by
  rw [setWidth_xor', extract_zext]

/-- **extract-zext-op** (^^^), extension on the right (code B2). -/
theorem extract_zext_xor_right {i n : Nat} (x : BitVec (i + 1)) (y : BitVec (i + 1 + n)) :
    (y ^^^ (x.setWidth (i + 1 + n))).setWidth (i + 1) = y.setWidth (i + 1) ^^^ x := by
  rw [setWidth_xor', extract_zext]

/-- **extract-zext-op** (+) [cav26]:
`(zext(n, x) + y)[i:0] → x + y[i:0]`, side condition `|x| = i + 1`. -/
theorem extract_zext_add {i n : Nat} (x : BitVec (i + 1)) (y : BitVec (i + 1 + n)) :
    ((x.setWidth (i + 1 + n)) + y).setWidth (i + 1) = x + y.setWidth (i + 1) := by
  rw [BitVec.setWidth_add _ _ (by omega), extract_zext]

/-- **extract-zext-op** (+), extension on the right (code B2). -/
theorem extract_zext_add_right {i n : Nat} (x : BitVec (i + 1)) (y : BitVec (i + 1 + n)) :
    (y + (x.setWidth (i + 1 + n))).setWidth (i + 1) = y.setWidth (i + 1) + x := by
  rw [BitVec.setWidth_add _ _ (by omega), extract_zext]

/-- **extract-zext-op** (-) [cav26]:
`(zext(n, x) - y)[i:0] → x - y[i:0]`, side condition `|x| = i + 1`. -/
theorem extract_zext_sub {i n : Nat} (x : BitVec (i + 1)) (y : BitVec (i + 1 + n)) :
    ((x.setWidth (i + 1 + n)) - y).setWidth (i + 1) = x - y.setWidth (i + 1) := by
  rw [setWidth_sub' _ _ (by omega), extract_zext]

/-- **extract-zext-op** (-), extension on the right (code B2). -/
theorem extract_zext_sub_right {i n : Nat} (x : BitVec (i + 1)) (y : BitVec (i + 1 + n)) :
    (y - (x.setWidth (i + 1 + n))).setWidth (i + 1) = y.setWidth (i + 1) - x := by
  rw [setWidth_sub' _ _ (by omega), extract_zext]

/-- **extract-zext-op** (*) [cav26]:
`(zext(n, x) * y)[i:0] → x * y[i:0]`, side condition `|x| = i + 1`. -/
theorem extract_zext_mul {i n : Nat} (x : BitVec (i + 1)) (y : BitVec (i + 1 + n)) :
    ((x.setWidth (i + 1 + n)) * y).setWidth (i + 1) = x * y.setWidth (i + 1) := by
  rw [BitVec.setWidth_mul _ _ (by omega), extract_zext]

/-- **extract-zext-op** (*), extension on the right (code B2). -/
theorem extract_zext_mul_right {i n : Nat} (x : BitVec (i + 1)) (y : BitVec (i + 1 + n)) :
    (y * (x.setWidth (i + 1 + n))).setWidth (i + 1) = y.setWidth (i + 1) * x := by
  rw [BitVec.setWidth_mul _ _ (by omega), extract_zext]

/-! ## extract-sext-low / extract-zext-low  (code: T1) -/

/-- **extract-sext-low**, narrow case [cav26]:
`sign_extend(n, x)[i:0] → x[i:0]`, side condition `i + 1 ≤ |x|`. -/
theorem extract_sext_low_narrow {p n i : Nat} (x : BitVec p) (h : i + 1 ≤ p) :
    (x.signExtend (p + n)).setWidth (i + 1) = x.setWidth (i + 1) :=
  setWidth_signExtend_low x h (by omega)

/-- **extract-sext-low**, wide case [cav26]:
`sign_extend(n, x)[i:0] → sign_extend(i + 1 - |x|, x)`, side condition
`|x| ≤ i + 1` (and `i + 1 ≤ |x| + n`, the in-range extract that the run-time
type constraints assert). -/
theorem extract_sext_low_wide {p n i : Nat} (x : BitVec p) (_h1 : p ≤ i + 1)
    (h2 : i + 1 ≤ p + n) :
    (x.signExtend (p + n)).setWidth (i + 1) = x.signExtend (i + 1) := by
  apply BitVec.eq_of_getLsbD_eq; intro j hj
  simp only [getLsbD_setWidth, getLsbD_signExtend]
  simp [hj, show j < p + n by omega]

/-- **extract-zext-low**, narrow case [cav26]: `zero_extend(n, x)[i:0] → x[i:0]`,
side condition `i + 1 ≤ |x|`. -/
theorem extract_zext_low_narrow {p n i : Nat} (x : BitVec p) (_h : i + 1 ≤ p) :
    (x.setWidth (p + n)).setWidth (i + 1) = x.setWidth (i + 1) :=
  setWidth_zeroExtend_low x (by omega)

/-- **extract-zext-low**, wide case [cav26]:
`zero_extend(n, x)[i:0] → zero_extend(i + 1 - |x|, x)`, side condition
`|x| ≤ i + 1` (and `i + 1 ≤ |x| + n`). -/
theorem extract_zext_low_wide {p n i : Nat} (x : BitVec p) (_h1 : p ≤ i + 1)
    (h2 : i + 1 ≤ p + n) :
    (x.setWidth (p + n)).setWidth (i + 1) = x.setWidth (i + 1) :=
  setWidth_zeroExtend_low x h2

/-! ## sext-zext  (code: E) -/

/-- **sext-zext** [cav26, `signed_zext`]:
`sign_extend(n, zero_extend(m, x)) → zero_extend(n + m, x)`, side condition `m ≥ 1`. -/
theorem sext_zext {p m n : Nat} (x : BitVec p) (hm : 1 ≤ m) :
    (x.setWidth (p + m)).signExtend (p + m + n) = x.setWidth (p + m + n) := by
  rw [signExtend_eq_setWidth_of_msb_false (msb_setWidth_of_lt x (by omega))]
  apply BitVec.eq_of_getLsbD_eq; intro j hj
  simp only [getLsbD_setWidth]
  by_cases h : j < p
  · simp [h, hj, show j < p + m by omega]
  · simp [BitVec.getLsbD_of_ge x j (by omega)]

/-- The side condition `m ≥ 1` of **sext-zext** is necessary. -/
theorem sext_zext_needs_m_pos :
    ¬ ∀ (p n : Nat) (x : BitVec p),
        (x.setWidth (p + 0)).signExtend (p + 0 + n) = x.setWidth (p + 0 + n) := by
  intro h
  have := h 1 1 1#1
  revert this; decide

/-! ## sext-sub-zext  (code: E2) -/

/-- Core of **sext-sub-zext**: two values with clear msb have a difference that
is representable as a signed value, so sign-extending it is subtracting the
zero extensions. -/
theorem signExtend_sub_of_msb_false {W V : Nat} (X Y : BitVec W) (hX : X.msb = false)
    (hY : Y.msb = false) (hV : W ≤ V) :
    (X - Y).signExtend V = X.setWidth V - Y.setWidth V := by
  apply BitVec.eq_of_toInt_eq
  have hx := msb_eq_false_iff_two_mul_lt.mp hX
  have hy := msb_eq_false_iff_two_mul_lt.mp hY
  rw [toInt_signExtend_of_le hV, toInt_sub, toInt_sub,
    ← signExtend_eq_setWidth_of_msb_false hX, ← signExtend_eq_setWidth_of_msb_false hY,
    toInt_signExtend_of_le hV, toInt_signExtend_of_le hV,
    toInt_eq_toNat_of_msb hX, toInt_eq_toNat_of_msb hY]
  have hWV : (2 : Int) ^ W ≤ 2 ^ V := pow_le_pow_right₀ (by decide) hV
  have hx' : 2 * (X.toNat : Int) < 2 ^ W := by exact_mod_cast hx
  have hy' : 2 * (Y.toNat : Int) < 2 ^ W := by exact_mod_cast hy
  have hx0 : (0 : Int) ≤ X.toNat := Int.natCast_nonneg _
  have hy0 : (0 : Int) ≤ Y.toNat := Int.natCast_nonneg _
  rw [Int.bmod_eq_of_le_mul_two (by push_cast; omega) (by push_cast; omega),
    Int.bmod_eq_of_le_mul_two (by push_cast; omega) (by push_cast; omega)]

/-- **sext-sub-zext** [cav26, `signed_of_diff`]:
`sign_extend(n, zero_extend(m₁, x) - zero_extend(m₂, y))
   → zero_extend(n, zero_extend(m₁, x)) - zero_extend(n, zero_extend(m₂, y))`,
side condition `m₁, m₂ ≥ 1` (here `W = |x| + m₁ = |y| + m₂`). -/
theorem sext_sub_zext {p q W n : Nat} (x : BitVec p) (y : BitVec q)
    (hm1 : p + 1 ≤ W) (hm2 : q + 1 ≤ W) :
    (x.setWidth W - y.setWidth W).signExtend (W + n)
      = (x.setWidth W).setWidth (W + n) - (y.setWidth W).setWidth (W + n) :=
  signExtend_sub_of_msb_false _ _ (msb_setWidth_of_lt x (by omega))
    (msb_setWidth_of_lt y (by omega)) (by omega)

/-! ## bitwise-sext-width / bitwise-zext-width  (code: X1, equal widths)

With `|x| = |y|` the two extension amounts `n, m` are forced equal by the
operator's typing, so the rules are stated with a single amount. -/

/-- **bitwise-sext-width** (and) [cav26]. -/
theorem bitwise_sext_width_and {p n : Nat} (x y : BitVec p) :
    x.signExtend (p + n) &&& y.signExtend (p + n) = (x &&& y).signExtend (p + n) :=
  signExtend_and.symm

/-- **bitwise-sext-width** (or) [cav26]. -/
theorem bitwise_sext_width_or {p n : Nat} (x y : BitVec p) :
    x.signExtend (p + n) ||| y.signExtend (p + n) = (x ||| y).signExtend (p + n) := by
  apply BitVec.eq_of_getLsbD_eq; intro j hj
  simp only [getLsbD_or, getLsbD_signExtend, msb_or]
  by_cases h : j < p <;> simp [h, hj]

/-- **bitwise-sext-width** (xor) [cav26]. -/
theorem bitwise_sext_width_xor {p n : Nat} (x y : BitVec p) :
    x.signExtend (p + n) ^^^ y.signExtend (p + n) = (x ^^^ y).signExtend (p + n) := by
  apply BitVec.eq_of_getLsbD_eq; intro j hj
  simp only [getLsbD_xor, getLsbD_signExtend, msb_xor]
  by_cases h : j < p <;> simp [h, hj]

/-- **bitwise-zext-width** (and) [cav26]. -/
theorem bitwise_zext_width_and {p n : Nat} (x y : BitVec p) :
    x.setWidth (p + n) &&& y.setWidth (p + n) = (x &&& y).setWidth (p + n) :=
  BitVec.setWidth_and.symm

/-- **bitwise-zext-width** (or) [cav26]. -/
theorem bitwise_zext_width_or {p n : Nat} (x y : BitVec p) :
    x.setWidth (p + n) ||| y.setWidth (p + n) = (x ||| y).setWidth (p + n) :=
  BitVec.setWidth_or.symm

/-- **bitwise-zext-width** (xor) [cav26]. -/
theorem bitwise_zext_width_xor {p n : Nat} (x y : BitVec p) :
    x.setWidth (p + n) ^^^ y.setWidth (p + n) = (x ^^^ y).setWidth (p + n) :=
  BitVec.setWidth_xor.symm

/-! ## eq-sext / eq-zext  (code: X3) -/

/-- **eq-sext** [cav26]: `sign_extend(n, x) = sign_extend(m, y) → x = y`,
side condition `|x| = |y|` (which forces `n = m`). -/
theorem eq_sext {p n : Nat} (x y : BitVec p) :
    x.signExtend (p + n) = y.signExtend (p + n) ↔ x = y := by
  constructor
  · intro h
    have := congrArg (BitVec.setWidth p) h
    rwa [setWidth_signExtend_low x (Nat.le_refl _) (by omega),
      setWidth_signExtend_low y (Nat.le_refl _) (by omega), setWidth_eq, setWidth_eq] at this
  · rintro rfl; rfl

/-- **eq-zext** [cav26]: `zero_extend(n, x) = zero_extend(m, y) → x = y`,
side condition `|x| = |y|`. -/
theorem eq_zext {p n : Nat} (x y : BitVec p) :
    x.setWidth (p + n) = y.setWidth (p + n) ↔ x = y := by
  constructor
  · intro h
    have := congrArg (BitVec.setWidth p) h
    rwa [setWidth_zeroExtend_low x (by omega), setWidth_zeroExtend_low y (by omega),
      setWidth_eq, setWidth_eq] at this
  · rintro rfl; rfl

/-! ## and-low-mask  (code: M2) -/

theorem low_mask_eq {w m : Nat} (hm1 : 1 ≤ m) (hm : m ≤ w) :
    (1#w <<< (BitVec.ofNat w m)) - 1#w = BitVec.ofNat w (2 ^ m - 1) := by
  have hmw : m % 2 ^ w = m := Nat.mod_eq_of_lt (Nat.lt_of_le_of_lt hm Nat.lt_two_pow_self)
  have hw : 1 % 2 ^ w = 1 := Nat.mod_eq_of_lt (Nat.one_lt_two_pow (by omega))
  have hpm : 2 ^ m ≤ 2 ^ w := Nat.pow_le_pow_right (by decide) hm
  have hp1 : 1 ≤ 2 ^ m := Nat.one_le_two_pow
  apply BitVec.eq_of_toNat_eq
  rw [toNat_sub, shiftLeft_eq', toNat_shiftLeft, toNat_ofNat, toNat_ofNat, toNat_ofNat,
    hmw, hw, Nat.shiftLeft_eq, Nat.one_mul, Nat.mod_eq_of_lt (by omega : 2 ^ m - 1 < 2 ^ w)]
  rcases Nat.lt_or_ge m w with h | h
  · have : 2 ^ m < 2 ^ w := Nat.pow_lt_pow_right (by decide) h
    rw [Nat.mod_eq_of_lt this, show 2 ^ w - 1 + 2 ^ m = (2 ^ m - 1) + 2 ^ w by omega,
      Nat.add_mod_right, Nat.mod_eq_of_lt (by omega)]
  · have : m = w := by omega
    subst this
    rw [Nat.mod_self, Nat.add_zero, Nat.mod_eq_of_lt (by omega)]

/-- **and-low-mask** [new]: `x & ((1 << m) - 1) → zero_extend(w - m, x[m-1:0])`,
side condition `1 ≤ m ≤ w = |x|`. -/
theorem and_low_mask {w m : Nat} (x : BitVec w) (hm1 : 1 ≤ m) (hm : m ≤ w) :
    x &&& ((1#w <<< (BitVec.ofNat w m)) - 1#w) = (x.setWidth m).setWidth w := by
  rw [low_mask_eq hm1 hm]
  apply BitVec.eq_of_getLsbD_eq; intro j hj
  simp only [getLsbD_and, getLsbD_ofNat, getLsbD_setWidth, Nat.testBit_two_pow_sub_one]
  by_cases h : j < m <;> simp [h, hj, Bool.and_comm]

/-! ## ite-mask  (code: K3) -/

/-- **ite-mask** [new]: `ite(x & y = 0, x & y', x) → x`, side condition `y = ~y'`
(an asserted or syntactic complement fact). -/
theorem ite_mask {w : Nat} (x y y' : BitVec w) (hy : y = ~~~y') :
    (if x &&& y = 0#w then x &&& y' else x) = x := by
  subst hy
  split
  · rename_i h
    apply BitVec.eq_of_getLsbD_eq; intro j hj
    have := congrArg (·.getLsbD j) h
    simp only [getLsbD_and, getLsbD_not, getLsbD_zero] at this
    simp only [getLsbD_and]
    cases hx : x.getLsbD j <;> cases hy : y'.getLsbD j <;> simp_all
  · rfl

/-! ## extract-shl-sext  (code: T5) -/

/-- **extract-shl-sext** [new]:
`(sign_extend(n, x) << z)[i:0] → (zero_extend(n, x) << z)[i:0]`,
side condition `i + 1 ≤ |x|`. -/
theorem extract_shl_sext {p n i : Nat} (x : BitVec p) (z : BitVec (p + n)) (h : i + 1 ≤ p) :
    ((x.signExtend (p + n)) <<< z).setWidth (i + 1)
      = ((x.setWidth (p + n)) <<< z).setWidth (i + 1) := by
  rw [shiftLeft_eq', shiftLeft_eq']
  apply BitVec.eq_of_getLsbD_eq; intro j hj
  simp only [getLsbD_setWidth, getLsbD_shiftLeft, getLsbD_signExtend]
  by_cases hz : j < z.toNat
  · simp [hz]
  · simp [hz, hj, show j - z.toNat < p by omega, show j - z.toNat < p + n by omega]

/-! ## sext-bit and its bitwise forms  (code: S1, S3) -/

theorem signExtend_bv1 {n : Nat} (c : BitVec 1) :
    c.signExtend (1 + n) = if c = 1#1 then allOnes (1 + n) else 0#(1 + n) := by
  rcases bv1_cases c with rfl | rfl
  · simp [signExtend_zero_one]
  · simp [signExtend_one_one]

/-- **sext-bit** [new]: `sign_extend(n, c) → -zero_extend(n, c)`, side condition `|c| = 1`. -/
theorem sext_bit {n : Nat} (c : BitVec 1) :
    c.signExtend (1 + n) = -(c.setWidth (1 + n)) := by
  rcases bv1_cases c with rfl | rfl
  · simp [signExtend_zero_one]
  · rw [signExtend_one_one, ← neg_one_eq_allOnes]
    congr 1
    apply BitVec.eq_of_toNat_eq
    simp

/-- **and-sext-bit** [new]: `sign_extend(n, c) & x → ite(c = 1, x, 0)`, `|c| = 1`. -/
theorem and_sext_bit {n : Nat} (c : BitVec 1) (x : BitVec (1 + n)) :
    c.signExtend (1 + n) &&& x = if c = 1#1 then x else 0#(1 + n) := by
  rw [signExtend_bv1]; split <;> simp

/-- **or-sext-bit** [new]: `sign_extend(n, c) | x → ite(c = 1, ones, x)`, `|c| = 1`. -/
theorem or_sext_bit {n : Nat} (c : BitVec 1) (x : BitVec (1 + n)) :
    c.signExtend (1 + n) ||| x = if c = 1#1 then allOnes (1 + n) else x := by
  rw [signExtend_bv1]; split <;> simp

/-- **xor-sext-bit** [new]: `sign_extend(n, c) ^ x → ite(c = 1, ~x, x)`, `|c| = 1`. -/
theorem xor_sext_bit {n : Nat} (c : BitVec 1) (x : BitVec (1 + n)) :
    c.signExtend (1 + n) ^^^ x = if c = 1#1 then ~~~x else x := by
  rw [signExtend_bv1]; split <;> simp

/-! ## sext-{gt,ge,lt,le}-min  (code: R, `lrSignedRange`)

`-2^m` at the comparison width `W` is any `N : BitVec W` with signed value
`-2^m`; `int_to_pbv(W, -2^m)` and the code's spelling `ones << m` are both
such an `N` when `m < W` (`ofInt_negPow2_toInt`, `ones_shl_toInt`). -/

theorem ofInt_negPow2_toInt {W m : Nat} (h : m < W) :
    (BitVec.ofInt W (-(2 ^ m : Int))).toInt = -(2 ^ m : Int) := by
  rw [toInt_ofInt]
  have : (2 : Int) ^ m * 2 ≤ 2 ^ W := by
    rw [← pow_succ]; exact pow_le_pow_right₀ (by decide) h
  have h3 : (0 : Int) < 2 ^ m := by positivity
  apply Int.bmod_eq_of_le_mul_two <;> push_cast <;> omega

theorem ones_shl_toInt {W m : Nat} (h : m < W) :
    (allOnes W <<< m).toInt = -(2 ^ m : Int) := by
  have e : allOnes W <<< m = BitVec.ofInt W (-(2 ^ m : Int)) := by
    rw [show (-(2 ^ m : Int)) = -((2 ^ m : Nat) : Int) by push_cast; rfl,
      BitVec.ofInt_neg, BitVec.ofInt_natCast, shiftLeft_eq_mul_twoPow,
      ← neg_one_eq_allOnes, BitVec.neg_mul, BitVec.one_mul]
    congr 1
    apply BitVec.eq_of_toNat_eq
    simp [toNat_twoPow]
    rw [Nat.pow_mod]
  rw [e, ofInt_negPow2_toInt h]

/-- `sign_extend` of a `p`-bit value lies strictly above `-2^m` for `p ≤ m`. -/
theorem negPow2_lt_sext {p W m : Nat} (x : BitVec p) (hp : p ≤ m) (hW : p ≤ W) :
    -(2 ^ m : Int) < (x.signExtend W).toInt := by
  rw [toInt_signExtend_of_le hW]
  have h1 := @le_two_mul_toInt p x
  have h2 : (2 : Int) ^ p ≤ 2 ^ m := pow_le_pow_right₀ (by decide) hp
  have h3 : (0 : Int) < 2 ^ m := by positivity
  omega

/-- **sext-gt-min** [new]: `-2^m <ₛ sign_extend(n, x) → true`, side condition `|x| ≤ m < W`. -/
theorem sext_gt_min {p W m : Nat} (x : BitVec p) (N : BitVec W) (hN : N.toInt = -(2 ^ m : Int))
    (hp : p ≤ m) (hW : p ≤ W) : N.slt (x.signExtend W) = true := by
  rw [slt_iff_toInt_lt, hN]; exact negPow2_lt_sext x hp hW

/-- **sext-ge-min** [new]: `-2^m ≤ₛ sign_extend(n, x) → true`, side condition `|x| ≤ m < W`. -/
theorem sext_ge_min {p W m : Nat} (x : BitVec p) (N : BitVec W) (hN : N.toInt = -(2 ^ m : Int))
    (hp : p ≤ m) (hW : p ≤ W) : N.sle (x.signExtend W) = true := by
  rw [sle_iff_toInt_le, hN]; exact le_of_lt (negPow2_lt_sext x hp hW)

/-- **sext-lt-min** [new]: `sign_extend(n, x) <ₛ -2^m → false`, side condition `|x| ≤ m < W`. -/
theorem sext_lt_min {p W m : Nat} (x : BitVec p) (N : BitVec W) (hN : N.toInt = -(2 ^ m : Int))
    (hp : p ≤ m) (hW : p ≤ W) : (x.signExtend W).slt N = false := by
  have := negPow2_lt_sext x hp hW
  rw [← hN] at this
  cases h : (x.signExtend W).slt N
  · rfl
  · rw [slt_iff_toInt_lt] at h; omega

/-- **sext-le-min** [new]: `sign_extend(n, x) ≤ₛ -2^m → false`, side condition `|x| ≤ m < W`. -/
theorem sext_le_min {p W m : Nat} (x : BitVec p) (N : BitVec W) (hN : N.toInt = -(2 ^ m : Int))
    (hp : p ≤ m) (hW : p ≤ W) : (x.signExtend W).sle N = false := by
  have := negPow2_lt_sext x hp hW
  rw [← hN] at this
  cases h : (x.signExtend W).sle N
  · rfl
  · rw [sle_iff_toInt_le] at h; omega

/-- **sext-gt-min / sext-lt-min** in the form the code matches (`lrSignedRange`):
`-2^m` spelled `ones << m`, under `m + 1 ≤ W` and `|x| ≤ m`. -/
theorem sext_signed_range_code {p W m : Nat} (x : BitVec p) (hm : m < W) (hp : p ≤ m)
    (hW : p ≤ W) :
    (allOnes W <<< m).slt (x.signExtend W) = true ∧
    (allOnes W <<< m).sle (x.signExtend W) = true ∧
    (x.signExtend W).slt (allOnes W <<< m) = false ∧
    (x.signExtend W).sle (allOnes W <<< m) = false :=
  ⟨sext_gt_min x _ (ones_shl_toInt hm) hp hW, sext_ge_min x _ (ones_shl_toInt hm) hp hW,
   sext_lt_min x _ (ones_shl_toInt hm) hp hW, sext_le_min x _ (ones_shl_toInt hm) hp hW⟩

end Pbv
