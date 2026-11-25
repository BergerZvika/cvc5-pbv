/-
Soundness of the vacuous-equality pass of Sect. `sec:exp-fermat`
(`--arith-fermat-vacuity`, `src/preprocessing/passes/arith_fermat_vacuity.cpp`).

The pass removes `c·v + Q = 0` (with `v` occurring nowhere else) when `c`
divides `Q` identically, binding `v := -Q div c`. Identical divisibility is
decided prime by prime (squarefree `c`, CRT) by reducing `Q` modulo `p`:
coefficients mod `p`, and every exponent `e ≥ 1` to `((e-1) mod (p-1)) + 1`.
We prove the soundness direction: if the reduced polynomial is zero over
`F_p`, then `p ∣ Q(x)` for every integer point `x`.
-/
import PbvProofs.Defs

namespace Pbv

open MvPolynomial

/-- Exponent reduction of the pass (`arith_fermat_vacuity.cpp:73`). -/
def reduceExp (p e : ℕ) : ℕ := if e = 0 then 0 else (e - 1) % (p - 1) + 1

/-- **Fermat exponent reduction**: for prime `p` and `e ≥ 1`,
`x^e ≡ x^(((e-1) mod (p-1)) + 1) (mod p)` for every integer `x`. -/
theorem fermat_exp_reduce (p : ℕ) [hp : Fact p.Prime] (e : ℕ) (he : 1 ≤ e) (x : ℤ) :
    x ^ e ≡ x ^ ((e - 1) % (p - 1) + 1) [ZMOD p] := by
  rw [← ZMod.intCast_eq_intCast_iff]
  push_cast
  set y : ZMod p := (x : ZMod p)
  by_cases hy : y = 0
  · rw [hy, zero_pow (by omega), zero_pow (by omega)]
  · have hdiv := Nat.div_add_mod (e - 1) (p - 1)
    have : e = (e - 1) % (p - 1) + 1 + (p - 1) * ((e - 1) / (p - 1)) := by omega
    conv_lhs => rw [this]
    rw [pow_add, pow_mul, ZMod.pow_card_sub_one_eq_one hy, one_pow, mul_one]

/-- `reduceExp` is sound for every exponent, including `e = 0`. -/
theorem reduceExp_sound (p : ℕ) [Fact p.Prime] (e : ℕ) (x : ℤ) :
    x ^ e ≡ x ^ reduceExp p e [ZMOD p] := by
  unfold reduceExp
  split_ifs with h
  · subst h; rfl
  · exact fermat_exp_reduce p e (by omega) x

/-- The paper's warning: reducing to `e mod (p-1)` instead is wrong —
`p = 3, e = 2, x = 0`: `0^2 = 0` but `0^(2 mod 2) = 0^0 = 1`. -/
theorem naive_exp_reduce_unsound :
    ¬ ∀ x : ℤ, x ^ 2 ≡ x ^ (2 % (3 - 1)) [ZMOD 3] := by
  intro h; have := h 0; revert this; decide

/-- **Coefficient reduction**: `a·m ≡ (a mod p)·m (mod p)`. -/
theorem coeff_reduce (p : ℕ) (a m : ℤ) : a * m ≡ (a % p) * m [ZMOD p] :=
  Int.ModEq.mul_right _ (Int.mod_modEq a p).symm

/-- The reduction of the pass on a polynomial: every coefficient mod `p`,
every exponent by `reduceExp`. (Collecting like terms is `MvPolynomial`'s
built-in normal form.) -/
noncomputable def fermatReduce {σ : Type*} (p : ℕ) (Q : MvPolynomial σ ℤ) : MvPolynomial σ ℤ :=
  ∑ m ∈ Q.support,
    monomial (m.mapRange (reduceExp p) (by simp [reduceExp])) (Q.coeff m % p)

theorem eval_monomial_cast {σ : Type*} (x : σ → ℤ) (m : σ →₀ ℕ) (a : ℤ) (p : ℕ) :
    ((eval x (monomial m a) : ℤ) : ZMod p) = (a : ZMod p) * m.prod fun i k => (x i : ZMod p) ^ k := by
  rw [eval_monomial]
  push_cast [Finsupp.prod]
  rfl

/-- **Reduction preserves the value mod `p`** at every integer point. -/
theorem fermatReduce_modEq {σ : Type*} (p : ℕ) [Fact p.Prime] (Q : MvPolynomial σ ℤ)
    (x : σ → ℤ) : eval x Q ≡ eval x (fermatReduce p Q) [ZMOD p] := by
  rw [← ZMod.intCast_eq_intCast_iff]
  conv_lhs => rw [Q.as_sum]
  unfold fermatReduce
  rw [map_sum, map_sum, Int.cast_sum, Int.cast_sum]
  refine Finset.sum_congr rfl fun m _ => ?_
  rw [eval_monomial_cast, eval_monomial_cast, ZMod.intCast_mod,
    Finsupp.prod_mapRange_index (by simp)]
  congr 1
  refine Finset.prod_congr rfl fun i _ => ?_
  have := reduceExp_sound p (m i) (x i)
  rw [← ZMod.intCast_eq_intCast_iff] at this
  push_cast at this
  exact this

/-- **Soundness of the prime test**: if the reduced polynomial is the zero
polynomial over `F_p` (every coefficient, after collecting like terms, is
divisible by `p`), then `p` divides `Q(x)` at every integer point. -/
theorem prime_vacuity_sound {σ : Type*} (p : ℕ) [Fact p.Prime] (Q : MvPolynomial σ ℤ)
    (hz : ∀ m, (p : ℤ) ∣ (fermatReduce p Q).coeff m) (x : σ → ℤ) :
    (p : ℤ) ∣ eval x Q := by
  have h1 := fermatReduce_modEq p Q x
  have h2 : (p : ℤ) ∣ eval x (fermatReduce p Q) := by
    rw [eval_eq]
    exact Finset.dvd_sum fun d _ => dvd_mul_of_dvd_left (hz d) _
  exact (Int.ModEq.dvd_iff h1).mpr h2

/-- **CRT step**: for squarefree `c`, if every prime factor of `c` divides `q`,
then `c` divides `q`. (The pass declines non-squarefree `c`,
`arith_fermat_vacuity.cpp:376`.) -/
theorem squarefree_dvd_of_primes (c : ℕ) (hc : Squarefree c) (q : ℤ)
    (h : ∀ p : ℕ, p.Prime → p ∣ c → (p : ℤ) ∣ q) : (c : ℤ) ∣ q := by
  rw [Int.natCast_dvd]
  rw [← Nat.prod_primeFactors_of_squarefree hc]
  apply Finset.prod_primes_dvd
  · intro a ha
    exact (Nat.prime_of_mem_primeFactors ha).prime
  · intro p hp
    exact Int.natCast_dvd.mp (h p (Nat.prime_of_mem_primeFactors hp) (Nat.dvd_of_mem_primeFactors hp))

/-- **Witness**: if `c ≠ 0` divides `Q`, then `v := -Q div c` satisfies `c·v + Q = 0`,
so deleting the equality and recording the substitution is sound. -/
theorem vacuity_witness (c Q : ℤ) (hdvd : c ∣ Q) : c * (-Q / c) + Q = 0 := by
  rw [Int.mul_ediv_cancel' (dvd_neg.mpr hdvd)]; ring

/-- **The whole pass** (soundness): squarefree `c ≥ 1`, and for each prime
`p ∣ c` the reduced polynomial vanishes over `F_p`. Then at every point the
equality `c·v + Q = 0` holds for `v := -Q(x) div c`. -/
theorem fermat_vacuity_sound {σ : Type*} (c : ℕ) (hc : Squarefree c) (Q : MvPolynomial σ ℤ)
    (hp : ∀ p : ℕ, (hp : p.Prime) →  p ∣ c →
      ∀ m, (p : ℤ) ∣ (fermatReduce p Q).coeff m)
    (x : σ → ℤ) : (c : ℤ) * (-(eval x Q) / c) + eval x Q = 0 := by
  apply vacuity_witness
  apply squarefree_dvd_of_primes c hc
  intro p hpp hpc
  have := Fact.mk hpp
  exact prime_vacuity_sound p Q (hp p hpp hpc) x

/-- The paper's example `size04.koat_141`: `Q = -8x³ - x + 12x²y + 6x² - 6xy - 3z - 6xy²`
is divisible by `3` at every integer point. -/
theorem koat_141_example (x y z : ℤ) :
    (3 : ℤ) ∣ -8 * x ^ 3 - x + 12 * x ^ 2 * y + 6 * x ^ 2 - 6 * x * y - 3 * z - 6 * x * y ^ 2 := by
  have h3 : (3 : ℤ) ∣ x ^ 3 - x := by
    have := fermat_exp_reduce 3 3 (by norm_num) x
    simp at this
    exact (Int.ModEq.dvd this.symm)
  obtain ⟨d, hd⟩ := h3
  exact ⟨-8 * d - 3 * x + 4 * x ^ 2 * y + 2 * x ^ 2 - 2 * x * y - z - 2 * x * y ^ 2, by linarith⟩

end Pbv
