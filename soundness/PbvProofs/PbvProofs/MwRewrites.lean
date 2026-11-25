/-
Soundness of the multi-width rewrite rules of the rewriter RW_B
(paper, Table `tab:mw-rewrites`, Section "Reasoning about Multiple
Bit-widths / Rewrite Rules") and of the two unsigned-division identities
added before the translation.

Parametric bit-vectors are `BitVec w` with the width `w` universally
quantified, so every theorem below holds at every (symbolic) width.
Admissibility (equal operand widths of a T_PBV operator) is the typing of
`BitVec`. Shift amounts are bit-vectors of the operand width, as in
SMT-LIB (`x <<< z`, `x >>> z`, `x.sshiftRight' z` shift by `z.toNat`, and
yield 0 / the sign fill once `z.toNat ≥ w`).
-/
import PbvProofs.Defs

namespace Pbv

open BitVec

/-! ### Parabit identities (Source: cav26) -/

-- xor-ones, not-plus-one, sext-sext, zext-zext, and-not (both sides) are RARE rules:
-- proved in `RarePbv.lean` (pbv_c26_xor_allones, pbv_c26_not_plus_one,
-- pbv_merge_sext, pbv_merge_zext, pbv_andn_right, pbv_andn_left).

/-! #### shift-bitwise (cav26): `(x sh z) ∘ (y sh z) → (x ∘ y) sh z`
for `∘ ∈ {&, |, ^}` and `sh ∈ {<<, >>, >>ₐ}`. -/

section ShiftBitwise
variable {w : Nat} (x y z : BitVec w)

theorem shift_bitwise_and_shl : (x <<< z) &&& (y <<< z) = (x &&& y) <<< z := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi
  simp only [shiftLeft_eq', getLsbD_and, getLsbD_shiftLeft]; cases decide (i < z.toNat) <;> simp [hi]

theorem shift_bitwise_or_shl : (x <<< z) ||| (y <<< z) = (x ||| y) <<< z := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi
  simp only [shiftLeft_eq', getLsbD_or, getLsbD_shiftLeft]; cases decide (i < z.toNat) <;> simp [hi]

theorem shift_bitwise_xor_shl : (x <<< z) ^^^ (y <<< z) = (x ^^^ y) <<< z := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi
  simp only [shiftLeft_eq', getLsbD_xor, getLsbD_shiftLeft]; cases decide (i < z.toNat) <;> simp [hi]

theorem shift_bitwise_and_lshr : (x >>> z) &&& (y >>> z) = (x &&& y) >>> z := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi
  simp [ushiftRight_eq', getLsbD_and, getLsbD_ushiftRight]

theorem shift_bitwise_or_lshr : (x >>> z) ||| (y >>> z) = (x ||| y) >>> z := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi
  simp [ushiftRight_eq', getLsbD_or, getLsbD_ushiftRight]

theorem shift_bitwise_xor_lshr : (x >>> z) ^^^ (y >>> z) = (x ^^^ y) >>> z := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi
  simp [ushiftRight_eq', getLsbD_xor, getLsbD_ushiftRight]

theorem shift_bitwise_and_ashr :
    x.sshiftRight' z &&& y.sshiftRight' z = (x &&& y).sshiftRight' z := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi
  simp only [getLsbD_and, getLsbD_sshiftRight', msb_and]
  by_cases h : z.toNat + i < w <;> simp [h, Nat.not_le.mpr hi]

theorem shift_bitwise_or_ashr :
    x.sshiftRight' z ||| y.sshiftRight' z = (x ||| y).sshiftRight' z := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi
  simp only [getLsbD_or, getLsbD_sshiftRight', msb_or]
  by_cases h : z.toNat + i < w <;> simp [h, Nat.not_le.mpr hi]

theorem shift_bitwise_xor_ashr :
    x.sshiftRight' z ^^^ y.sshiftRight' z = (x ^^^ y).sshiftRight' z := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi
  simp only [getLsbD_xor, getLsbD_sshiftRight', msb_xor]
  by_cases h : z.toNat + i < w <;> simp [h, Nat.not_le.mpr hi]

end ShiftBitwise

/-- **shl-lshr** (cav26): `x & (~0 >> z) → (x << z) >> z`. -/
theorem shl_lshr {w : Nat} (x z : BitVec w) :
    x &&& (allOnes w >>> z) = (x <<< z) >>> z := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi
  simp only [shiftLeft_eq', ushiftRight_eq', getLsbD_and, getLsbD_ushiftRight,
    getLsbD_allOnes, getLsbD_shiftLeft]
  by_cases h : z.toNat + i < w <;> simp [h]

/-- **lshr-shl** (cav26): `x & (~0 << z) → (x >> z) << z`. -/
theorem lshr_shl {w : Nat} (x z : BitVec w) :
    x &&& (allOnes w <<< z) = (x >>> z) <<< z := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi
  simp only [shiftLeft_eq', ushiftRight_eq', getLsbD_and, getLsbD_ushiftRight,
    getLsbD_allOnes, getLsbD_shiftLeft]
  by_cases h : i < z.toNat
  · simp [h]
  · simp [h, hi, show z.toNat + (i - z.toNat) = i by omega]; intro; omega

/-- **sext-ite** (cav26): `ite(c, sext(n,x), sext(n,y)) → sext(n, ite(c,x,y))`. -/
theorem sext_ite {w : Nat} (v : Nat) (c : Prop) [Decidable c] (x y : BitVec w) :
    (if c then x.signExtend v else y.signExtend v) = (if c then x else y).signExtend v := by
  split <;> rfl

/-- **zext-ite** (cav26): `ite(c, zext(n,x), zext(n,y)) → zext(n, ite(c,x,y))`. -/
theorem zext_ite {w : Nat} (v : Nat) (c : Prop) [Decidable c] (x y : BitVec w) :
    (if c then x.setWidth v else y.setWidth v) = (if c then x else y).setWidth v := by
  split <;> rfl

/-! ### New rules (Source: new) -/

private theorem ofNat_pred_toNat (k : Nat) : (BitVec.ofNat k (k - 1)).toNat = k - 1 := by
  rw [toNat_ofNat]; apply Nat.mod_eq_of_lt
  exact lt_of_le_of_lt (Nat.sub_le k 1) (Nat.lt_two_pow_self)

/-- **sign-bit-and** (new): `x & (1 << (k-1)) = 0 → ¬(x <s 0)`, the shift amount
being the `k`-bit constant `k-1`. -/
theorem sign_bit_and {k : Nat} (x : BitVec k) :
    (x &&& (1#k <<< BitVec.ofNat k (k - 1)) = 0#k) ↔ ¬ (x.slt 0#k = true) := by
  rw [slt_zero_iff_msb_cond, msb_eq_getLsbD_last]
  constructor
  · intro h hm
    have := congrArg (fun v => v.getLsbD (k - 1)) h
    simp only [shiftLeft_eq', ofNat_pred_toNat, getLsbD_and, getLsbD_shiftLeft,
      getLsbD_zero] at this
    have hk : 0 < k := by
      rcases Nat.eq_zero_or_pos k with h0 | h0
      · subst h0; simp at hm
      · exact h0
    rw [getLsbD_eq_getElem (by omega)] at hm
    simp [hk] at this; simp [this] at hm
  · intro hm
    apply BitVec.eq_of_getLsbD_eq; intro i hi
    simp only [shiftLeft_eq', ofNat_pred_toNat, getLsbD_and, getLsbD_shiftLeft, getLsbD_zero,
      getLsbD_one]
    by_cases h : i = k - 1
    · subst h; simp [hm]
    · simp; intro _ _ _; omega

/-- **ashr-sign** (new): `x >>ₐ (k-1) → ite(x <s 0, ~0, 0)`. -/
theorem ashr_sign {k : Nat} (x : BitVec k) :
    x.sshiftRight' (BitVec.ofNat k (k - 1)) = if x.slt 0#k then allOnes k else 0#k := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi
  rw [getLsbD_sshiftRight', ofNat_pred_toNat]
  have hm : x.slt 0#k = x.msb := by rw [Bool.eq_iff_iff, slt_zero_iff_msb_cond]
  rw [hm]
  by_cases h0 : i = 0
  · subst h0
    have : k - 1 + 0 < k := by omega
    rw [ite_eq_left this, Nat.add_zero, ← msb_eq_getLsbD_last]
    cases hb : x.msb <;> simp [hi] <;> omega
  · have : ¬ (k - 1 + i < k) := by omega
    cases hb : x.msb <;> simp [this, hb, hi, Nat.not_le.mpr hi]

/-- **and-lshr-mask** (new): `(~0 >> z) & (x >> z) → x >> z`. -/
theorem and_lshr_mask {w : Nat} (x z : BitVec w) :
    (allOnes w >>> z) &&& (x >>> z) = x >>> z := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi
  simp only [ushiftRight_eq', getLsbD_and, getLsbD_ushiftRight, getLsbD_allOnes]
  by_cases h : z.toNat + i < w
  · simp [h]
  · simp [h, getLsbD_of_ge x _ (Nat.le_of_not_lt h)]

/-- The ite-mask `m = ite(c, 0, ~0)`. -/
abbrev iteMask (w : Nat) (c : Prop) [Decidable c] : BitVec w := if c then 0#w else allOnes w

/-- **and-ite-mask** (new): `ite(c, 0, ~0) & x → ite(c, 0, x)`. -/
theorem and_ite_mask {w : Nat} (c : Prop) [Decidable c] (x : BitVec w) :
    iteMask w c &&& x = if c then 0#w else x := by
  unfold iteMask; split <;> simp

/-- **or-ite-mask** (new): `ite(c, 0, ~0) | x → ite(c, x, ~0)`. -/
theorem or_ite_mask {w : Nat} (c : Prop) [Decidable c] (x : BitVec w) :
    iteMask w c ||| x = if c then x else allOnes w := by
  unfold iteMask; split <;> simp

/-- **xor-ite-mask** (new): `ite(c, 0, ~0) ^ x → ite(c, x, ~x)`. -/
theorem xor_ite_mask {w : Nat} (c : Prop) [Decidable c] (x : BitVec w) :
    iteMask w c ^^^ x = if c then x else ~~~x := by
  unfold iteMask; split <;> simp [BitVec.allOnes_xor]

/-- **add-ite-mask** (new): `ite(c, 0, ~0) + x → ite(c, x, x - 1)`. -/
theorem add_ite_mask {w : Nat} (c : Prop) [Decidable c] (x : BitVec w) :
    iteMask w c + x = if c then x else x - 1#w := by
  unfold iteMask; split
  · simp
  · rw [BitVec.add_comm, ← BitVec.neg_one_eq_allOnes, ← BitVec.sub_eq_add_neg]

/-- **sext-zero** (new): `sext(n, 0_w) → 0_{w+n}`. -/
theorem sext_zero (w v : Nat) : (0#w).signExtend v = 0#v := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi
  simp [getLsbD_signExtend, msb_zero]

/-- **zext-zero** (new): `zext(n, 0_w) → 0_{w+n}`. -/
theorem zext_zero (w v : Nat) : (0#w).setWidth v = 0#v := by simp

/-! #### bitwise-sext / bitwise-zext (new): `ext(n,x) ∘ ext(n,y) → ext(n, x ∘ y)` -/

section BitwiseExt
variable {w : Nat} (v : Nat) (x y : BitVec w)

theorem bitwise_sext_and : x.signExtend v &&& y.signExtend v = (x &&& y).signExtend v := by
  ext i hi; simp [getElem_signExtend]

theorem bitwise_sext_or : x.signExtend v ||| y.signExtend v = (x ||| y).signExtend v := by
  ext i hi; simp [getElem_signExtend]

theorem bitwise_sext_xor : x.signExtend v ^^^ y.signExtend v = (x ^^^ y).signExtend v := by
  ext i hi; simp [getElem_signExtend]

theorem bitwise_zext_and : x.setWidth v &&& y.setWidth v = (x &&& y).setWidth v := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi; simp [hi]

theorem bitwise_zext_or : x.setWidth v ||| y.setWidth v = (x ||| y).setWidth v := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi; simp [hi]

theorem bitwise_zext_xor : x.setWidth v ^^^ y.setWidth v = (x ^^^ y).setWidth v := by
  apply BitVec.eq_of_getLsbD_eq; intro i hi; simp [hi]

end BitwiseExt

/-! #### flip (new): `x ⋈ₛ y → (x + h) ⋈ᵤ (y + h)`, `h = int_to_pbv(k, 2^(k-1))` -/

section Flip
variable {k : Nat}

/-- The sign threshold `h = 2^(k-1)` as a `k`-bit constant. -/
abbrev signH (k : Nat) : BitVec k := BitVec.ofNat k (2 ^ (k - 1))

/-- Adding `h` maps the signed order onto the unsigned one: the biased value
is `x.toInt + 2^(k-1)` read as a natural number. -/
theorem toNat_add_signH (hk : 0 < k) (x : BitVec k) :
    ((x + signH k).toNat : Int) = x.toInt + 2 ^ (k - 1) := by
  · have hP : 2 ^ k = 2 * 2 ^ (k - 1) := by
      rw [← Nat.pow_succ']; congr 1; omega
    have hx := x.isLt
    have hmsb := @msb_eq_true_iff_two_mul_ge k x
    have hh : (signH k).toNat = 2 ^ (k - 1) := by
      simp only [signH, toNat_ofNat]; apply Nat.mod_eq_of_lt; omega
    rw [toNat_add, hh, toInt_eq_msb_cond]
    by_cases hm : x.msb = true
    · have h2 : 2 ^ (k - 1) ≤ x.toNat := by have := hmsb.mp hm; omega
      rw [ite_eq_left hm, Nat.mod_eq_sub_mod (by omega), Nat.mod_eq_of_lt (by omega),
        Nat.cast_sub (by omega)]
      push_cast; omega
    · have h2 : x.toNat < 2 ^ (k - 1) := by have := mt hmsb.mpr hm; omega
      rw [ite_eq_right hm, Nat.mod_eq_of_lt (by omega)]; push_cast; ring

theorem flip_slt (x y : BitVec k) : x.slt y = (x + signH k).ult (y + signH k) := by
  rcases Nat.eq_zero_or_pos k with hk | hk
  · subst hk; rw [BitVec.eq_nil x, BitVec.eq_nil y]; decide
  have h1 := toNat_add_signH hk x; have h2 := toNat_add_signH hk y
  rw [Bool.eq_iff_iff, slt_iff_toInt_lt, ult_iff_lt, BitVec.lt_def]; omega

theorem flip_sle (x y : BitVec k) : x.sle y = (x + signH k).ule (y + signH k) := by
  rcases Nat.eq_zero_or_pos k with hk | hk
  · subst hk; rw [BitVec.eq_nil x, BitVec.eq_nil y]; decide
  have h1 := toNat_add_signH hk x; have h2 := toNat_add_signH hk y
  rw [Bool.eq_iff_iff, sle_iff_toInt_le, ule_iff_le, BitVec.le_def]; omega

/-- `x >ₛ y` is `y <ₛ x`. -/
theorem flip_sgt (x y : BitVec k) : y.slt x = (y + signH k).ult (x + signH k) := flip_slt y x

/-- `x ≥ₛ y` is `y ≤ₛ x`. -/
theorem flip_sge (x y : BitVec k) : y.sle x = (y + signH k).ule (x + signH k) := flip_sle y x

end Flip

/-! ### Unsigned-division identities (added before the translation, `--pbv-div-lemmas`)

PBV `bvudiv` by zero is all-ones in SMT-LIB, whereas Lean's `BitVec` `/` by
zero is `0`; the hypotheses below exclude zero divisors, so the two agree. -/

/-- `(x / a) / b = x / (a * b)` when `a * b` does not overflow and `a, b ≠ 0`. -/
theorem udiv_udiv {w : Nat} (x a b : BitVec w) (ha : a ≠ 0#w) (hb : b ≠ 0#w)
    (hov : a.toNat * b.toNat < 2 ^ w) : x / a / b = x / (a * b) := by
  apply BitVec.eq_of_toNat_eq
  rw [toNat_udiv, toNat_udiv, toNat_udiv, toNat_mul, Nat.mod_eq_of_lt hov, Nat.div_div_eq_div_mul]

/-- `(x * a) / c = x / (c / a)` when `x * a` does not overflow, `a, c ≠ 0`, and `a ∣ c`. -/
theorem udiv_mul_udiv {w : Nat} (x a c : BitVec w) (ha : a ≠ 0#w) (hc : c ≠ 0#w)
    (hov : x.toNat * a.toNat < 2 ^ w) (hdvd : a.toNat ∣ c.toNat) :
    x * a / c = x / (c / a) := by
  have ha' : 0 < a.toNat := Nat.pos_of_ne_zero (fun h => ha (BitVec.eq_of_toNat_eq (by simpa using h)))
  apply BitVec.eq_of_toNat_eq
  rw [toNat_udiv, toNat_udiv, toNat_udiv, toNat_mul, Nat.mod_eq_of_lt hov]
  obtain ⟨q, hq⟩ := hdvd
  rw [hq, Nat.mul_div_cancel_left _ ha', Nat.mul_comm x.toNat, Nat.mul_div_mul_left _ _ ha']

/-- The no-overflow test of `pbv_div_lemmas.cpp` (`noOverflow`):
`extract(zext(w,p) * zext(w,q), 2w-1, w) = 0` iff `p * q < 2^w`. -/
theorem noOverflow_iff {w : Nat} (p q : BitVec w) :
    (p.setWidth (2 * w) * q.setWidth (2 * w)).extractLsb' w w = 0#w ↔
      p.toNat * q.toNat < 2 ^ w := by
  have hp := p.isLt; have hq := q.isLt
  have hlt : p.toNat * q.toNat < 2 ^ (2 * w) := by
    rw [show 2 * w = w + w by omega, Nat.pow_add]
    exact Nat.mul_lt_mul'' hp hq
  rw [← BitVec.toNat_inj, extractLsb'_toNat, toNat_mul,
    toNat_setWidth_of_le (by omega), toNat_setWidth_of_le (by omega), Nat.mod_eq_of_lt hlt,
    toNat_ofNat, Nat.zero_mod, Nat.shiftRight_eq_div_pow]
  constructor
  · intro h
    rcases Nat.eq_zero_or_pos w with h0 | h0
    · subst h0; simp at hp hq; simp [hp]
    have hd := Nat.div_add_mod (p.toNat * q.toNat) (2 ^ w)
    have hmod : p.toNat * q.toNat / 2 ^ w < 2 ^ w := by
      rw [Nat.div_lt_iff_lt_mul (by positivity), ← Nat.pow_add]
      rwa [show 2 * w = w + w by omega] at hlt
    rw [Nat.mod_eq_of_lt hmod] at h
    rw [Nat.div_eq_zero_iff_lt (by positivity)] at h; exact h
  · intro h; rw [Nat.div_eq_of_lt h]; simp

/-- **D2 exactly as emitted** (`pbv_div_lemmas.cpp`): the premise is
`noOverflow(x, a) ∧ c urem a = 0 ∧ c ≠ 0`, with no explicit `a ≠ 0`. It is
implied: SMT-LIB (and Lean) `c urem 0 = c ≠ 0`. -/
theorem udiv_mul_udiv_code {w : Nat} (x a c : BitVec w) (hc : c ≠ 0#w)
    (hov : x.toNat * a.toNat < 2 ^ w) (hrem : c % a = 0#w) :
    x * a / c = x / (c / a) := by
  have ha : a ≠ 0#w := by rintro rfl; simp at hrem; exact hc hrem
  have hdvd : a.toNat ∣ c.toNat := by
    have := congrArg BitVec.toNat hrem
    rw [toNat_umod, toNat_ofNat, Nat.zero_mod] at this
    exact Nat.dvd_of_mod_eq_zero this
  exact udiv_mul_udiv x a c ha hc hov hdvd

/-- The no-overflow hypothesis of `udiv_udiv` is needed (width 2: `x = 3, a = 2, b = 3`, `a * b` wraps to `2`). -/
theorem udiv_udiv_needs_no_overflow :
    ¬ ∀ x a b : BitVec 2, a ≠ 0#2 → b ≠ 0#2 → x / a / b = x / (a * b) := by
  intro h; have := h 3#2 2#2 3#2 (by decide) (by decide); revert this; decide

end Pbv
