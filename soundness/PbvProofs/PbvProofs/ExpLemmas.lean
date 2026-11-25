/-
Soundness of the lemma schemas of the EXP solver (paper Table `tab:lem-exp`)
under SMT-LIB `**` semantics (`Pbv.smtExp`).
-/
import PbvProofs.Defs

namespace Pbv

/-! ### Helpers -/

theorem smtExp_negNat (s : Int) {n : Nat} (hn : 0 < n) :
    smtExp s (-(n : Int)) = 1 / s ^ n := by
  rw [smtExp_of_neg (by omega)]
  simp

/-- Euclidean `1 div x`: only the units survive. -/
theorem one_ediv_cases (x : Int) :
    1 / x = if x = 1 then 1 else if x = -1 then -1 else 0 := by
  by_cases h1 : x = 1
  · subst h1; simp
  by_cases h2 : x = -1
  · subst h2; simp
  simp only [h1, h2, ite_false]
  rcases lt_trichotomy x 0 with h | h | h
  · have : x = -(-x) := by ring
    rw [this, Int.ediv_neg, Int.ediv_eq_zero_of_lt (by norm_num) (by omega)]
    simp
  · subst h; simp
  · exact Int.ediv_eq_zero_of_lt (by norm_num) (by omega)

theorem one_ediv_mul (x y : Int) : 1 / (x * y) = (1 / x) * (1 / y) := by
  rw [one_ediv_cases x, one_ediv_cases y, one_ediv_cases (x * y)]
  have k1 := @Int.eq_one_or_neg_one_of_mul_eq_one' x y
  have k2 := @Int.eq_one_or_neg_one_of_mul_eq_neg_one' x y
  split_ifs <;> simp_all

/-- Split an exponent into the non-negative and the negative case. -/
theorem int_cases_nat (t : Int) : (∃ n : Nat, t = n) ∨ (∃ n : Nat, 0 < n ∧ t = -(n : Int)) := by
  rcases le_or_gt 0 t with h | h
  · exact Or.inl ⟨t.toNat, by omega⟩
  · exact Or.inr ⟨(-t).toNat, by omega, by omega⟩

/-! ### Schemas over a single term `exp(s,t)` -/

/-- **positive** (\[sat25\]): `(s > 0 ∧ t ≥ 0) ⇒ exp(s,t) > 0`. -/
theorem exp_positive (s t : Int) (hs : 0 < s) (ht : 0 ≤ t) : 0 < smtExp s t := by
  rw [smtExp_of_nonneg ht]; positivity

/-- **even** (\[sat25\]): `(s mod 2 = 0 ∧ t ≥ 1) ⇒ exp(s,t) mod 2 = 0`. -/
theorem exp_even (s t : Int) (hs : s % 2 = 0) (ht : 1 ≤ t) : smtExp s t % 2 = 0 := by
  rw [smtExp_of_nonneg (by omega)]
  have h2 : (2 : Int) ∣ s := Int.dvd_of_emod_eq_zero hs
  exact Int.emod_eq_zero_of_dvd (Dvd.dvd.pow h2 (by omega))

/-- `t < s^t` for `s ≥ 2`, `t ≥ 0`. -/
theorem lt_pow_of_two_le (s : Int) (n : Nat) (hs : 2 ≤ s) : (n : Int) < s ^ n := by
  have h1 : (n : Int) < 2 ^ n := by exact_mod_cast Nat.lt_two_pow_self
  exact lt_of_lt_of_le h1 (pow_le_pow_left₀ (by norm_num) hs n)

/-- **div-exp** (\[sat25\]): `(s ≥ 2 ∧ t ≥ 0) ⇒ t div exp(s,t) = 0`. -/
theorem exp_div_exp (s t : Int) (hs : 2 ≤ s) (ht : 0 ≤ t) : t / smtExp s t = 0 := by
  obtain ⟨n, rfl⟩ : ∃ n : Nat, t = n := ⟨t.toNat, by omega⟩
  rw [smtExp_natCast]
  exact Int.ediv_eq_zero_of_lt (by omega) (lt_pow_of_two_le s n hs)

/-- `exp(s,t) = 0` for `t < 0` and `|s| > 1`. -/
theorem smtExp_neg_big (s t : Int) (ht : t < 0) (hs : 1 < s ∨ s < -1) : smtExp s t = 0 := by
  obtain ⟨n, hn, rfl⟩ : ∃ n : Nat, 0 < n ∧ t = -(n : Int) := ⟨(-t).toNat, by omega, by omega⟩
  rw [smtExp_negNat s hn, one_ediv_cases]
  have habs : 2 ≤ |s| := by rcases hs with h | h <;> [rw [abs_of_pos (by omega)]; rw [abs_of_neg (by omega)]] <;> omega
  have hp : 2 ≤ |s ^ n| := by
    rw [abs_pow]
    calc (2 : Int) = 2 ^ 1 := by norm_num
      _ ≤ 2 ^ n := pow_le_pow_right₀ (by norm_num) hn
      _ ≤ |s| ^ n := pow_le_pow_left₀ (by norm_num) habs n
  have h1 : s ^ n ≠ 1 := by intro h; rw [h] at hp; norm_num at hp
  have h2 : s ^ n ≠ -1 := by intro h; rw [h] at hp; norm_num at hp
  simp [h1, h2]

/-- **neg** (\[sat25\]): `(t < 0 ∧ (s > 1 ∨ s < -1)) ⇒ exp(s,t) = 0`. -/
theorem exp_neg (s t : Int) (ht : t < 0) (hs : 1 < s ∨ s < -1) : smtExp s t = 0 :=
  smtExp_neg_big s t ht hs

/-- **value** (\[sat25\]): `(s = v ∧ t = w) ⇒ exp(s,t) = v^w`, where `v^w` is the
constant `**` evaluated by the rewriter (code: `valueBasedLemma`, which rewrites
`(exp v w)`). -/
theorem exp_value (s t v w : Int) (hs : s = v) (ht : t = w) : smtExp s t = smtExp v w := by
  subst hs ht; rfl

/-- `2 t^2 < 2^t` for `t ≥ 7`. -/
theorem two_sq_lt_two_pow (n : Nat) (hn : 7 ≤ n) : 2 * (n : Int) ^ 2 < 2 ^ n := by
  induction n, hn using Nat.le_induction with
  | base => norm_num
  | succ m hm ih =>
    push_cast
    have : 2 * ((m : Int) + 1) ^ 2 ≤ 2 * (2 * (m : Int) ^ 2) := by nlinarith
    calc 2 * ((m : Int) + 1) ^ 2 ≤ 2 * (2 * (m : Int) ^ 2) := this
      _ < 2 * 2 ^ m := by linarith
      _ = 2 ^ (m + 1) := by ring

/-- **bound** (\[sat25\]): `(s ≥ 2 ∧ 7 ≤ w ∧ w ≤ t) ⇒ w·t + w² < exp(s,t)`. -/
theorem exp_bound (s t w : Int) (hs : 2 ≤ s) (hw : 7 ≤ w) (hwt : w ≤ t) :
    w * t + w ^ 2 < smtExp s t := by
  obtain ⟨n, rfl⟩ : ∃ n : Nat, t = n := ⟨t.toNat, by omega⟩
  rw [smtExp_natCast]
  have h1 := two_sq_lt_two_pow n (by omega)
  have h2 : (2 : Int) ^ n ≤ s ^ n := pow_le_pow_left₀ (by norm_num) hs n
  nlinarith

/-- **div-base** (\[sat25\]): `(s ≥ 2 ∧ t ≥ 2) ⇒ s div exp(s,t) = 0`. -/
theorem exp_div_base (s t : Int) (hs : 2 ≤ s) (ht : 2 ≤ t) : s / smtExp s t = 0 := by
  obtain ⟨n, rfl⟩ : ∃ n : Nat, t = n := ⟨t.toNat, by omega⟩
  rw [smtExp_natCast]
  apply Int.ediv_eq_zero_of_lt (by omega)
  calc s = s ^ 1 := (pow_one s).symm
    _ < s ^ n := pow_lt_pow_right₀ (by omega) (by omega)

/-- **zero** (bnd₁, \[SwInE\]): `t = 0 ⇒ exp(s,t) = 1`. -/
theorem exp_zero (s t : Int) (ht : t = 0) : smtExp s t = 1 := by
  subst ht; simp

/-- **one** (bnd₄, \[SwInE\]): `s = 1 ⇒ exp(s,t) = 1`. -/
theorem exp_one (s t : Int) (hs : s = 1) : smtExp s t = 1 := by
  subst hs; unfold smtExp; split_ifs <;> simp

/-- **neg-def** (new): `t < 0 ⇒ exp(s,t) = 1 div exp(s,-t)`. -/
theorem exp_neg_def (s t : Int) (ht : t < 0) : smtExp s t = 1 / smtExp s (-t) := by
  rw [smtExp_of_neg ht, smtExp_of_nonneg (by omega)]

/-- **non-negative** (new): `s ≥ 0 ⇒ exp(s,t) ≥ 0`. -/
theorem exp_non_negative (s t : Int) (hs : 0 ≤ s) : 0 ≤ smtExp s t := by
  unfold smtExp; split_ifs
  · positivity
  · exact Int.ediv_nonneg (by norm_num) (by positivity)

/-- **odd** (new): `(s mod 2 = 1 ∧ t ≥ 0) ⇒ exp(s,t) mod 2 = 1`. -/
theorem exp_odd (s t : Int) (hs : s % 2 = 1) (ht : 0 ≤ t) : smtExp s t % 2 = 1 := by
  rw [smtExp_of_nonneg ht]
  have : Odd s := Int.odd_iff.mpr hs
  exact Int.odd_iff.mp (this.pow)

/-- The guard `t ≥ 0` of **odd** is needed: `exp(3,-1) = 0` is even. -/
theorem exp_odd_needs_guard : ¬ ∀ s t : Int, s % 2 = 1 → smtExp s t % 2 = 1 := by
  intro h; have := h 3 (-1) (by decide); revert this; decide

theorem neg_one_pow_parity (n : Nat) :
    (-1 : Int) ^ n = if (n : Int) % 2 = 0 then 1 else -1 := by
  rcases Nat.even_or_odd n with h | h
  · rw [h.neg_one_pow]
    have : (n : Int) % 2 = 0 := by obtain ⟨k, rfl⟩ := h; push_cast; omega
    simp [this]
  · rw [h.neg_one_pow]
    have : (n : Int) % 2 = 1 := by obtain ⟨k, rfl⟩ := h; push_cast; omega
    simp [this]

/-- **parity-minus-one** (new):
`s = -1 ⇒ ite(t mod 2 = 0, exp(s,t) = 1, exp(s,t) = -1)`. -/
theorem exp_parity_minus_one (s t : Int) (hs : s = -1) :
    if t % 2 = 0 then smtExp s t = 1 else smtExp s t = -1 := by
  subst hs
  rcases int_cases_nat t with ⟨n, rfl⟩ | ⟨n, hn, rfl⟩
  · rw [smtExp_natCast, neg_one_pow_parity]; split_ifs <;> rfl
  · rw [smtExp_negNat _ hn, neg_one_pow_parity]
    have : (-(n : Int)) % 2 = 0 ↔ (n : Int) % 2 = 0 := by omega
    by_cases h : (n : Int) % 2 = 0 <;> simp [h]

/-- **mod-base** (new): `(s ≠ 0 ∧ t ≠ 0) ⇒ exp(s,t) mod s = 0`. -/
theorem exp_mod_base (s t : Int) (hs : s ≠ 0) (ht : t ≠ 0) : smtExp s t % s = 0 := by
  rcases int_cases_nat t with ⟨n, rfl⟩ | ⟨n, hn, rfl⟩
  · rw [smtExp_natCast]
    exact Int.emod_eq_zero_of_dvd (dvd_pow_self s (by omega))
  · by_cases hu : s = 1 ∨ s = -1
    · rcases hu with rfl | rfl <;> simp
    · rw [smtExp_neg_big s _ (by omega) (by omega)]; simp

/-! #### prime -/

/-- **prime** (\[SwInE\]) without the guard `t ≥ 0`:
`p ∣ exp(s,t) ⇔ (p ∣ s ∧ t ≠ 0)` for a prime `p`.
Unsound for negative exponents: `exp(3,-1) = 0` is divisible by `2`, but `2 ∤ 3`. -/
theorem exp_prime_unguarded_unsound :
    ¬ ∀ (p : Nat) (s t : Int), p.Prime → ((p : Int) ∣ smtExp s t ↔ ((p : Int) ∣ s ∧ t ≠ 0)) := by
  intro h
  have := (h 2 3 (-1) Nat.prime_two).mp (by decide)
  exact absurd this.1 (by decide)

/-- **prime**, forward direction (sound for every exponent; this is what the code
emits, `exp_solver.cpp` `checkPrimeLemma`): `(p ∣ s ∧ t ≠ 0) ⇒ p ∣ exp(s,t)`. -/
theorem exp_prime_fwd (p : Nat) (s t : Int) (hp : p.Prime) (hs : (p : Int) ∣ s) (ht : t ≠ 0) :
    (p : Int) ∣ smtExp s t := by
  rcases int_cases_nat t with ⟨n, rfl⟩ | ⟨n, hn, rfl⟩
  · rw [smtExp_natCast]; exact Dvd.dvd.pow hs (by omega)
  · have hp2 : 2 ≤ (p : Int) := by exact_mod_cast hp.two_le
    by_cases hu : s = 1 ∨ s = -1
    · exfalso
      rcases hu with rfl | rfl
      · have := Int.le_of_dvd (by norm_num) hs; omega
      · have := Int.le_of_dvd (by norm_num) (dvd_neg.mp hs); omega
    · by_cases h0 : s = 0
      · subst h0; rw [smtExp_negNat _ hn, zero_pow (by omega)]; simp
      · rw [smtExp_neg_big s _ (by omega) (by omega)]; simp

/-- **prime**, converse, guarded by `t > 0` as in the code: `(t > 0 ∧ p ∣ exp(s,t)) ⇒ p ∣ s`. -/
theorem exp_prime_conv (p : Nat) (s t : Int) (hp : p.Prime) (ht : 0 < t)
    (h : (p : Int) ∣ smtExp s t) : (p : Int) ∣ s := by
  obtain ⟨n, rfl⟩ : ∃ n : Nat, t = n := ⟨t.toNat, by omega⟩
  rw [smtExp_natCast] at h
  exact (Nat.prime_iff_prime_int.mp hp).dvd_of_dvd_pow h

/-- **prime** as in the paper: `t ≥ 0 ⇒ (p ∣ exp(s,t) ⇔ (p ∣ s ∧ t ≠ 0))`. -/
theorem exp_prime (p : Nat) (s t : Int) (hp : p.Prime) (ht : 0 ≤ t) :
    (p : Int) ∣ smtExp s t ↔ ((p : Int) ∣ s ∧ t ≠ 0) := by
  constructor
  · intro h
    have ht0 : t ≠ 0 := by
      rintro rfl; simp at h
      have := Int.le_of_dvd (by norm_num) h
      have := hp.two_le; omega
    exact ⟨exp_prime_conv p s t hp (by omega) h, ht0⟩
  · rintro ⟨h1, h2⟩; exact exp_prime_fwd p s t hp h1 h2

/-! ### Schemas over a pair of terms -/

/-- **induction** (\[SwInE\]):
`(s₁ = s₂ ∧ t₂ - d = t₁ ∧ t₁ ≥ 0) ⇒ exp(s₂,t₂) = exp(s₁,t₁) · s₁^d` (`d > 0` a numeral). -/
theorem exp_induction (s1 s2 t1 t2 : Int) (d : Nat) (hs : s1 = s2) (hd : t2 - d = t1)
    (ht : 0 ≤ t1) : smtExp s2 t2 = smtExp s1 t1 * s1 ^ d := by
  subst hs
  obtain ⟨n, rfl⟩ : ∃ n : Nat, t1 = n := ⟨t1.toNat, by omega⟩
  obtain rfl : t2 = ((n + d : Nat) : Int) := by push_cast; omega
  simp only [smtExp_natCast, pow_add]

/-- **fuse-base** (\[SwInE\]): `t₁ = t₂ ⇒ exp(s₁,t₁) · exp(s₂,t₂) = exp(s₁·s₂,t₁)`.
Unguarded, and sound also for negative exponents. -/
theorem exp_fuse_base (s1 s2 t1 t2 : Int) (ht : t1 = t2) :
    smtExp s1 t1 * smtExp s2 t2 = smtExp (s1 * s2) t1 := by
  subst ht
  rcases int_cases_nat t1 with ⟨n, rfl⟩ | ⟨n, hn, rfl⟩
  · simp [mul_pow]
  · rw [smtExp_negNat _ hn, smtExp_negNat _ hn, smtExp_negNat _ hn, mul_pow, one_ediv_mul]

/-- **monotonicity** (\[SwInE\]):
`(2 ≤ s₁ ≤ s₂ ∧ 0 ≤ t₁ ≤ t₂ ∧ 1 ≤ t₂ ∧ (s₁ < s₂ ∨ t₁ < t₂)) ⇒ exp(s₁,t₁) < exp(s₂,t₂)`. -/
theorem exp_monotonicity (s1 s2 t1 t2 : Int) (h1 : 2 ≤ s1) (h2 : s1 ≤ s2) (h3 : 0 ≤ t1)
    (h4 : t1 ≤ t2) (h5 : 1 ≤ t2) (h6 : s1 < s2 ∨ t1 < t2) : smtExp s1 t1 < smtExp s2 t2 := by
  obtain ⟨m, rfl⟩ : ∃ m : Nat, t1 = m := ⟨t1.toNat, by omega⟩
  obtain ⟨n, rfl⟩ : ∃ n : Nat, t2 = n := ⟨t2.toNat, by omega⟩
  simp only [smtExp_natCast]
  have hmn : m ≤ n := by omega
  rcases h6 with h | h
  · calc s1 ^ m ≤ s1 ^ n := pow_le_pow_right₀ (by omega) hmn
      _ < s2 ^ n := pow_lt_pow_left₀ h (by omega) (by omega)
  · calc s1 ^ m < s1 ^ n := pow_lt_pow_right₀ (by omega) (by omega)
      _ ≤ s2 ^ n := pow_le_pow_left₀ (by omega) h2 n

/-- **sym-even** (\[SwInE\]):
`(s₁ = -s₂ ∧ t₁ = t₂ ∧ t₁ mod 2 = 0) ⇒ exp(s₁,t₁) = exp(s₂,t₂)`. -/
theorem exp_sym_even (s1 s2 t1 t2 : Int) (hs : s1 = -s2) (ht : t1 = t2) (he : t1 % 2 = 0) :
    smtExp s1 t1 = smtExp s2 t2 := by
  subst hs ht
  rcases int_cases_nat t1 with ⟨n, rfl⟩ | ⟨n, hn, rfl⟩
  · have : Even n := by rw [Nat.even_iff]; omega
    simp [this.neg_pow]
  · have : Even n := by rw [Nat.even_iff]; omega
    rw [smtExp_negNat _ hn, smtExp_negNat _ hn, this.neg_pow]

/-- **sym-odd** (\[SwInE\]):
`(s₁ = -s₂ ∧ t₁ = t₂ ∧ t₁ mod 2 = 1) ⇒ exp(s₁,t₁) = -exp(s₂,t₂)`. -/
theorem exp_sym_odd (s1 s2 t1 t2 : Int) (hs : s1 = -s2) (ht : t1 = t2) (ho : t1 % 2 = 1) :
    smtExp s1 t1 = -smtExp s2 t2 := by
  subst hs ht
  rcases int_cases_nat t1 with ⟨n, rfl⟩ | ⟨n, hn, rfl⟩
  · have : Odd n := by rw [Nat.odd_iff]; omega
    simp [this.neg_pow]
  · have : Odd n := by rw [Nat.odd_iff]; omega
    rw [smtExp_negNat _ hn, smtExp_negNat _ hn, this.neg_pow, Int.ediv_neg]

/-- **neg-minus-one** (\[SwInE\], the sound instance of the third symmetry lemma):
`(s = -1 ∧ t < 0) ⇒ exp(s,t) = exp(s,-t)`. -/
theorem exp_neg_minus_one (s t : Int) (hs : s = -1) (ht : t < 0) :
    smtExp s t = smtExp s (-t) := by
  subst hs
  obtain ⟨n, hn, rfl⟩ : ∃ n : Nat, 0 < n ∧ t = -(n : Int) := ⟨(-t).toNat, by omega, by omega⟩
  rw [smtExp_negNat _ hn, neg_neg, smtExp_natCast]
  rcases neg_one_pow_eq_or Int n with h | h <;> rw [h] <;> decide

/-- The unguarded third symmetry lemma `exp(s,t) = exp(s,-t)` of SwInE is unsound
under `**` (removed from cvc5): `exp(2,1) = 2 ≠ 0 = exp(2,-1)`. -/
theorem exp_sym3_unsound : ¬ ∀ s t : Int, smtExp s t = smtExp s (-t) := by
  intro h; have := h 2 1; revert this; decide

/-- **compose** (\[SwInE\], guarded):
`(y ≥ 0 ∧ z ≥ 0) ⇒ exp(exp(x,y),z) = exp(x,y·z)`. -/
theorem exp_compose (x y z : Int) (hy : 0 ≤ y) (hz : 0 ≤ z) :
    smtExp (smtExp x y) z = smtExp x (y * z) := by
  obtain ⟨m, rfl⟩ : ∃ m : Nat, y = m := ⟨y.toNat, by omega⟩
  obtain ⟨n, rfl⟩ : ∃ n : Nat, z = n := ⟨z.toNat, by omega⟩
  rw [← Nat.cast_mul]
  simp only [smtExp_natCast, pow_mul]

/-- The unguarded composition rule is unsound under `**`:
`x = y = z = -6` gives `exp(0,-6) = 0` vs. `(-6)^36`. -/
theorem exp_compose_unguarded_unsound :
    ¬ ∀ x y z : Int, smtExp (smtExp x y) z = smtExp x (y * z) := by
  intro h; have := h (-6) (-6) (-6); revert this; decide

/-- Companion lemma emitted by the code next to **compose** (`checkComposeRefine`):
`(y < 0 ∧ (x > 1 ∨ x < -1) ∧ z ≠ 0) ⇒ exp(exp(x,y),z) = 0`. -/
theorem exp_compose_neg_inner (x y z : Int) (hy : y < 0) (hx : 1 < x ∨ x < -1) (hz : z ≠ 0) :
    smtExp (smtExp x y) z = 0 := by
  rw [smtExp_neg_big x y hy hx]
  rcases int_cases_nat z with ⟨n, rfl⟩ | ⟨n, hn, rfl⟩
  · rw [smtExp_natCast, zero_pow (by omega)]
  · rw [smtExp_negNat _ hn, zero_pow (by omega)]; simp

/-- **fuse** (new):
`(s₁ = s₂ ∧ t₁ ≥ 0 ∧ t₂ ≥ 0) ⇒ exp(s₁,t₁) · exp(s₂,t₂) = exp(s₁,t₁+t₂)`. -/
theorem exp_fuse (s1 s2 t1 t2 : Int) (hs : s1 = s2) (h1 : 0 ≤ t1) (h2 : 0 ≤ t2) :
    smtExp s1 t1 * smtExp s2 t2 = smtExp s1 (t1 + t2) := by
  subst hs
  obtain ⟨m, rfl⟩ : ∃ m : Nat, t1 = m := ⟨t1.toNat, by omega⟩
  obtain ⟨n, rfl⟩ : ∃ n : Nat, t2 = n := ⟨t2.toNat, by omega⟩
  rw [← Nat.cast_add]
  simp only [smtExp_natCast, pow_add]

/-- The same-base fusion needs its guards: `exp(2,1)·exp(2,-1) = 0 ≠ 1 = exp(2,0)`. -/
theorem exp_fuse_unguarded_unsound :
    ¬ ∀ s t1 t2 : Int, smtExp s t1 * smtExp s t2 = smtExp s (t1 + t2) := by
  intro h; have := h 2 1 (-1); revert this; decide

/-- Every value of `exp(s,t)` with `t < 0` is in `{-1,0,1}`. -/
theorem smtExp_neg_le_one (s t : Int) (ht : t < 0) : smtExp s t ≤ 1 := by
  rw [smtExp_of_neg ht, one_ediv_cases]; split_ifs <;> omega

/-- **divisible** (new):
`(s₁ = s₂ ∧ 0 < exp(s₁,t₁) ≤ exp(s₂,t₂)) ⇒ exp(s₂,t₂) mod exp(s₁,t₁) = 0`.
Sound as printed (no `t₁ ≥ 0` guard needed; the code adds one anyway). -/
theorem exp_divisible (s1 s2 t1 t2 : Int) (hs : s1 = s2) (hpos : 0 < smtExp s1 t1)
    (hle : smtExp s1 t1 ≤ smtExp s2 t2) : smtExp s2 t2 % smtExp s1 t1 = 0 := by
  subst hs
  apply Int.emod_eq_zero_of_dvd
  by_cases h1 : smtExp s1 t1 = 1
  · rw [h1]; exact one_dvd _
  have hgt : 1 < smtExp s1 t1 := by omega
  -- t1 ≥ 0, since negative exponents give values ≤ 1
  have ht1 : 0 ≤ t1 := by
    by_contra h; have := smtExp_neg_le_one s1 t1 (by omega); omega
  have ht2 : 0 ≤ t2 := by
    by_contra h; have := smtExp_neg_le_one s1 t2 (by omega); omega
  obtain ⟨m, rfl⟩ : ∃ m : Nat, t1 = m := ⟨t1.toNat, by omega⟩
  obtain ⟨n, rfl⟩ : ∃ n : Nat, t2 = n := ⟨t2.toNat, by omega⟩
  simp only [smtExp_natCast] at *
  -- |s1| ≥ 2: the bases 0, 1, -1 only produce values in {-1, 0, 1}
  have habs : 2 ≤ |s1| := by
    by_contra h
    have hs : s1 = 0 ∨ s1 = 1 ∨ s1 = -1 := by
      rcases abs_cases s1 with ⟨h', _⟩ | ⟨h', _⟩ <;> omega
    rcases hs with rfl | rfl | rfl
    · rcases Nat.eq_zero_or_pos m with rfl | hm
      · simp at h1
      · rw [zero_pow (by omega)] at hgt; omega
    · simp at hgt
    · rcases neg_one_pow_eq_or Int m with h' | h' <;> rw [h'] at hgt <;> omega
  have hmn : m ≤ n := by
    by_contra h
    have : |s1| ^ n < |s1| ^ m := pow_lt_pow_right₀ (by omega) (by omega)
    have e1 : |s1 ^ m| = s1 ^ m := abs_of_pos (by omega)
    have e2 : |s1 ^ n| = s1 ^ n := abs_of_pos (by omega)
    rw [← abs_pow, ← abs_pow, e1, e2] at this
    omega
  exact pow_dvd_pow s1 hmn

/-! ### Same-exponent groups: order-min, order-chain, collapse

The paper groups numeral bases `2 ≤ b₁ < … < b_k` (as the code,
`preprocessing/passes/exp_base_order.cpp`, `constBase`) and states the
guards `b₁ ≥ 1` (order-min) and `0 ≤ b₁` (order-chain), which are necessary. -/

/-- **order-min** (new) without the guard `b₁ ≥ 1` is unsound:
`exp(0,1) = 0`. -/
theorem exp_order_min_unguarded_unsound : ¬ ∀ b e : Int, 0 ≤ e → 1 ≤ smtExp b e := by
  intro h; have := h 0 1 (by decide); revert this; decide

/-- **order-min** as in the paper: `(b₁ ≥ 1 ∧ e ≥ 0) ⇒ exp(b₁,e) ≥ 1` (code: `b₁ ≥ 2`). -/
theorem exp_order_min (b e : Int) (hb : 1 ≤ b) (he : 0 ≤ e) : 1 ≤ smtExp b e := by
  rw [smtExp_of_nonneg he]; exact one_le_pow₀ hb

/-- **order-chain** (new) without the guard `0 ≤ b₁` is unsound:
`b₁ = -3 < b₂ = 2`, `e = 2`: `4 < 9`. -/
theorem exp_order_chain_unguarded_unsound :
    ¬ ∀ b1 b2 e : Int, b1 < b2 → 0 ≤ e → smtExp b1 e ≤ smtExp b2 e := by
  intro h; have := h (-3) 2 2 (by decide) (by decide); revert this; decide

/-- **order-chain** as in the paper: `(0 ≤ b₁ < b₂ ∧ e ≥ 0) ⇒ exp(b₂,e) ≥ exp(b₁,e)`
(code: `b₁ ≥ 2`). -/
theorem exp_order_chain (b1 b2 e : Int) (h0 : 0 ≤ b1) (hb : b1 < b2) (he : 0 ≤ e) :
    smtExp b1 e ≤ smtExp b2 e := by
  rw [smtExp_of_nonneg he, smtExp_of_nonneg he]
  exact pow_le_pow_left₀ h0 hb.le _

/-- **collapse** (new): `(b₁ < b₂ ∧ e ≥ 0) ⇒ exp(b₂,e) = (exp(b₁,e))^j` for `b₂ = b₁^j`.
Sound for every base. -/
theorem exp_collapse (b1 b2 e : Int) (j : Nat) (hj : b2 = b1 ^ j) (he : 0 ≤ e) :
    smtExp b2 e = (smtExp b1 e) ^ j := by
  subst hj
  rw [smtExp_of_nonneg he, smtExp_of_nonneg he, ← pow_mul, ← pow_mul, mul_comm]

/-- **collapse** holds even without the guard `e ≥ 0`: for negative exponents
`1 div x` is multiplicative (`one_ediv_mul`). -/
theorem exp_collapse_unguarded (b1 e : Int) (j : Nat) :
    smtExp (b1 ^ j) e = (smtExp b1 e) ^ j := by
  rcases int_cases_nat e with ⟨n, rfl⟩ | ⟨n, hn, rfl⟩
  · simp only [smtExp_natCast, ← pow_mul, mul_comm]
  · rw [smtExp_negNat _ hn, smtExp_negNat _ hn, ← pow_mul, mul_comm, pow_mul]
    induction j with
    | zero => simp
    | succ j ih => rw [pow_succ, one_ediv_mul, ih, pow_succ]

/-! ### Interpolation (\[SwInE\])

We prove the integer, denominator-cleared form that the code emits
(`exp_solver.cpp`, `checkInterpolationLemma`, lambda `buildRhs`). The proofs use
discrete convexity: `F` has non-decreasing first differences on `ℕ`. -/

/-- Discrete convexity on `ℕ`. -/
def DConvex (F : Nat → Int) : Prop := ∀ n, F (n + 1) - F n ≤ F (n + 2) - F (n + 1)

theorem DConvex.mono {F : Nat → Int} (hF : DConvex F) {a b : Nat} (h : a ≤ b) :
    F (a + 1) - F a ≤ F (b + 1) - F b := by
  induction b, h using Nat.le_induction with
  | base => exact le_rfl
  | succ b _ ih => exact ih.trans (hF b)

theorem DConvex.sum_ge {F : Nat → Int} (hF : DConvex F) (n k : Nat) :
    (k : Int) * (F (n + 1) - F n) ≤ F (n + k) - F n := by
  induction k with
  | zero => simp
  | succ k ih =>
    have := hF.mono (show n ≤ n + k by omega)
    rw [show n + (k + 1) = n + k + 1 by omega]
    push_cast; linarith

theorem DConvex.sum_le {F : Nat → Int} (hF : DConvex F) (n k : Nat) :
    F (n + k) - F n ≤ (k : Int) * (F (n + k + 1) - F (n + k)) := by
  induction k with
  | zero => simp
  | succ k ih =>
    have h1 := hF (n + k)
    have hk : (0 : Int) ≤ k := by positivity
    have h2 : (k : Int) * (F (n + k + 1) - F (n + k)) ≤
        (k : Int) * (F (n + k + 2) - F (n + k + 1)) := mul_le_mul_of_nonneg_left h1 hk
    rw [show n + (k + 1) = n + k + 1 by omega, show n + k + 1 + 1 = n + k + 2 by omega]
    push_cast; linarith

/-- Secant property *outside* `(c, c+1)`: every integer point is outside. -/
theorem DConvex.outside {F : Nat → Int} (hF : DConvex F) (c x : Nat) :
    F c + (F (c + 1) - F c) * ((x : Int) - c) ≤ F x := by
  rcases le_or_gt c x with h | h
  · obtain ⟨k, rfl⟩ := Nat.exists_eq_add_of_le h
    have := hF.sum_ge c k; push_cast; linarith
  · obtain ⟨k, rfl⟩ := Nat.exists_eq_add_of_le h.le
    have := hF.sum_le x k; push_cast; linarith

/-- Secant property *inside* `[a, b]`. -/
theorem DConvex.inside {F : Nat → Int} (hF : DConvex F) (a x b : Nat) (hax : a ≤ x) (hxb : x ≤ b) :
    ((b : Int) - a) * F x ≤ ((b : Int) - x) * F a + ((x : Int) - a) * F b := by
  obtain ⟨i, rfl⟩ := Nat.exists_eq_add_of_le hax
  obtain ⟨j, rfl⟩ := Nat.exists_eq_add_of_le hxb
  have h1 := hF.sum_le a i
  have h2 := hF.sum_ge (a + i) j
  have hi : (0 : Int) ≤ i := by positivity
  have hj : (0 : Int) ≤ j := by positivity
  have e1 := mul_le_mul_of_nonneg_left h1 hj
  have e2 := mul_le_mul_of_nonneg_left h2 hi
  push_cast at *
  nlinarith

/-- `n ↦ n^e` is discretely convex on `ℕ`. -/
theorem dconvex_pow (e : Nat) : DConvex (fun n => (n : Int) ^ e) := by
  intro n
  simp only; push_cast
  induction e with
  | zero => simp
  | succ e ih =>
    have hD : (0 : Int) ≤ ((n : Int) + 1 + 1) ^ e - ((n : Int) + 1) ^ e := by
      have : ((n : Int) + 1) ^ e ≤ ((n : Int) + 1 + 1) ^ e := pow_le_pow_left₀ (by positivity) (by linarith) e
      linarith
    have hn : (0 : Int) ≤ n := by positivity
    have key : (((n : Int) + 2) ^ (e + 1) - ((n : Int) + 1) ^ (e + 1)) -
        (((n : Int) + 1) ^ (e + 1) - (n : Int) ^ (e + 1)) =
        (n : Int) * ((((n : Int) + 2) ^ e - ((n : Int) + 1) ^ e) - (((n : Int) + 1) ^ e - (n : Int) ^ e))
        + 2 * (((n : Int) + 2) ^ e - ((n : Int) + 1) ^ e) := by ring
    have : (n : Int) + 1 + 1 = n + 2 := by ring
    rw [this] at hD
    have := mul_nonneg hn (sub_nonneg.mpr ih)
    rw [show (n : Int) + 1 + 1 = n + 2 by ring] at *
    linarith

/-- `n ↦ n^(e+1) - n^e` is discretely convex on `ℕ`. -/
theorem dconvex_pow_succ_sub (e : Nat) :
    DConvex (fun n => (n : Int) ^ (e + 1) - (n : Int) ^ e) := by
  intro n
  have hp := dconvex_pow e n
  simp only at hp ⊢; push_cast at hp ⊢
  have hD1 : ((n : Int) + 1) ^ e ≤ ((n : Int) + 2) ^ e := pow_le_pow_left₀ (by positivity) (by linarith) e
  have hD0 : (n : Int) ^ e ≤ ((n : Int) + 1) ^ e := pow_le_pow_left₀ (by positivity) (by linarith) e
  have hn : (0 : Int) ≤ n := by positivity
  have := mul_nonneg hn (sub_nonneg.mpr hp)
  have key : (((n : Int) + 2) ^ (e + 1) - ((n : Int) + 2) ^ e) - 2 * (((n : Int) + 1) ^ (e + 1) - ((n : Int) + 1) ^ e)
      + ((n : Int) ^ (e + 1) - (n : Int) ^ e) =
      (n : Int) * ((((n : Int) + 2) ^ e - ((n : Int) + 1) ^ e) - (((n : Int) + 1) ^ e - (n : Int) ^ e))
      + (((n : Int) + 2) ^ e - ((n : Int) + 1) ^ e) + (((n : Int) + 1) ^ e - (n : Int) ^ e) := by ring
  linarith

/-- For a base `x ≥ 0`, `n ↦ x^n` is discretely convex: second difference `x^n (x-1)^2`. -/
theorem dconvex_exp (x : Int) (hx : 0 ≤ x) : DConvex (fun n => x ^ n) := by
  intro n
  simp only
  have : x ^ (n + 2) - x ^ (n + 1) - (x ^ (n + 1) - x ^ n) = x ^ n * (x - 1) ^ 2 := by ring
  have : 0 ≤ x ^ n * (x - 1) ^ 2 := by positivity
  linarith

/-- The cleared-denominator right-hand side `buildRhs(cLo,cHi,dLo,dHi)` of the code,
i.e. `Pm·Qm · ip^{[cLo,cHi][dLo,dHi]}(s,t)` with `Pm = (cHi-cLo or 1)`,
`Qm = (dHi-dLo or 1)`. -/
def ipRhs (cLo cHi : Int) (dLo dHi : Nat) (s t : Int) : Int :=
  let P := cHi - cLo
  let Q := (dHi : Int) - dLo
  let Pm := if P = 0 then 1 else P
  let Qm := if Q = 0 then 1 else Q
  let AP := cLo ^ dLo * Pm + (cHi ^ dLo - cLo ^ dLo) * (s - cLo)
  let BP := cLo ^ dHi * Pm + (cHi ^ dHi - cLo ^ dHi) * (s - cLo)
  AP * Qm + (BP - AP) * (t - dLo)

/-- The scale `Pm·Qm` multiplying `exp(s,t)` on the left of the code's lemma. -/
def ipScale (cLo cHi : Int) (dLo dHi : Nat) : Int :=
  (if cHi - cLo = 0 then 1 else cHi - cLo) * (if (dHi : Int) - dLo = 0 then 1 else (dHi : Int) - dLo)

/-- Base direction of the upper bound. -/
theorem ip_base_step (a b x e : Nat) (hax : a ≤ x) (hxb : x ≤ b) :
    (if (b : Int) - a = 0 then 1 else (b : Int) - a) * (x : Int) ^ e ≤
      (a : Int) ^ e * (if (b : Int) - a = 0 then 1 else (b : Int) - a) +
        ((b : Int) ^ e - (a : Int) ^ e) * ((x : Int) - a) := by
  split_ifs with h
  · have : x = a := by omega
    subst this; simp
  · have := (dconvex_pow e).inside a x b hax hxb
    nlinarith

/-- **interpolate-upper** (\[SwInE\]), in the form emitted by the code, for a box
with `c⁻ ≥ 0` and `d⁻ ≥ 0` as in the paper (the code only uses points with `c, d ≥ 1`):
`(cLo ≤ s ≤ cHi ∧ dLo ≤ t ≤ dHi) ⇒ Pm·Qm·exp(s,t) ≤ buildRhs`. -/
theorem exp_interpolate_upper (cLo cHi : Int) (dLo dHi : Nat) (s t : Int) (hc : 0 ≤ cLo)
    (h1 : cLo ≤ s) (h2 : s ≤ cHi) (h3 : (dLo : Int) ≤ t) (h4 : t ≤ dHi) :
    ipScale cLo cHi dLo dHi * smtExp s t ≤ ipRhs cLo cHi dLo dHi s t := by
  obtain ⟨a, rfl⟩ : ∃ a : Nat, cLo = a := ⟨cLo.toNat, by omega⟩
  obtain ⟨b, rfl⟩ : ∃ b : Nat, cHi = b := ⟨cHi.toNat, by omega⟩
  obtain ⟨x, rfl⟩ : ∃ x : Nat, s = x := ⟨s.toNat, by omega⟩
  obtain ⟨y, rfl⟩ : ∃ y : Nat, t = y := ⟨t.toNat, by omega⟩
  have hax : a ≤ x := by omega
  have hxb : x ≤ b := by omega
  have hly : dLo ≤ y := by omega
  have hyh : y ≤ dHi := by omega
  rw [smtExp_natCast]
  unfold ipScale ipRhs
  simp only
  have hA := ip_base_step a b x dLo hax hxb
  have hB := ip_base_step a b x dHi hax hxb
  have hPm : (0 : Int) < (if (b : Int) - a = 0 then 1 else (b : Int) - a) := by
    split_ifs <;> omega
  set Pm := (if (b : Int) - a = 0 then 1 else (b : Int) - a)
  set AP := (a : Int) ^ dLo * Pm + ((b : Int) ^ dLo - (a : Int) ^ dLo) * ((x : Int) - a)
  set BP := (a : Int) ^ dHi * Pm + ((b : Int) ^ dHi - (a : Int) ^ dHi) * ((x : Int) - a)
  split_ifs with hQ
  · have : y = dLo := by omega
    subst this; simp only [sub_self, mul_zero, add_zero, mul_one]; exact hA
  · have hE := (dconvex_exp (x : Int) (by positivity)).inside dLo y dHi hly hyh
    have u1 : (0 : Int) ≤ (dHi : Int) - y := by omega
    have u2 : (0 : Int) ≤ (y : Int) - dLo := by omega
    have e1 := mul_le_mul_of_nonneg_left hA u1
    have e2 := mul_le_mul_of_nonneg_left hB u2
    have e3 := mul_le_mul_of_nonneg_left hE hPm.le
    nlinarith

/-- The guard `c⁻ ≥ 0` of **interpolate-upper** is necessary (the code returns early
unless `c, d ≥ 1`): box `{-2} × [1,3]`, point `(-2,2)`. -/
theorem exp_interpolate_upper_neg_base_unsound :
    ¬ ∀ (cLo cHi : Int) (dLo dHi : Nat) (s t : Int), cLo ≤ s → s ≤ cHi → (dLo : Int) ≤ t →
      t ≤ dHi → ipScale cLo cHi dLo dHi * smtExp s t ≤ ipRhs cLo cHi dLo dHi s t := by
  intro h
  have := h (-2) (-2) 1 3 (-2) 2 (by decide) (by decide) (by decide) (by decide)
  revert this; decide

/-- The code's lower-bound right-hand side over the unit box `[c,c+1] × [d,d+1]`
(all denominators are 1). -/
def ipLowerRhs (c : Int) (d : Nat) (s t : Int) : Int :=
  let AP := c ^ d + ((c + 1) ^ d - c ^ d) * (s - c)
  let BP := c ^ (d + 1) + ((c + 1) ^ (d + 1) - c ^ (d + 1)) * (s - c)
  AP + (BP - AP) * (t - d)

theorem ipLowerRhs_eq (c : Int) (d : Nat) (s t : Int) :
    ipLowerRhs c d s t = ipRhs c (c + 1) d (d + 1) s t := by
  unfold ipLowerRhs ipRhs; simp

/-- **interpolate-lower** (\[SwInE\]), as emitted by the code:
`(s ≥ 1 ∧ t ≥ w) ⇒ exp(s,t) ≥ ip^{[v,v+1][w,w+1]}(s,t)`, for `v ≥ 0`, `w ≥ 0`
(the code requires `v, w ≥ 1`). -/
theorem exp_interpolate_lower (c : Int) (d : Nat) (s t : Int) (hc : 0 ≤ c) (hs : 1 ≤ s)
    (ht : (d : Int) ≤ t) : ipLowerRhs c d s t ≤ smtExp s t := by
  obtain ⟨a, rfl⟩ : ∃ a : Nat, c = a := ⟨c.toNat, by omega⟩
  obtain ⟨x, rfl⟩ : ∃ x : Nat, s = x := ⟨s.toNat, by omega⟩
  obtain ⟨m, rfl⟩ : ∃ m : Nat, t = ((d + m : Nat) : Int) := ⟨(t - d).toNat, by omega⟩
  rw [smtExp_natCast]
  unfold ipLowerRhs; simp only
  have hF := (dconvex_pow d).outside a x
  have hG := (dconvex_pow_succ_sub d).outside a x
  have hH := (dconvex_exp (x : Int) (by positivity)).sum_ge d m
  push_cast at *
  have hm : (0 : Int) ≤ m := by positivity
  have := mul_le_mul_of_nonneg_left hG hm
  have hx : (x : Int) ^ (d + 1) = (x : Int) ^ d * x := pow_succ _ _
  nlinarith

end Pbv
