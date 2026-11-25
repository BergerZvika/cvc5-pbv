; ∀ (c : BitVec 1) (wt : Int), 1 < wt →
;   ofBool (signExtend wt c >ᵤ zeroExtend wt c) = c
; (same as zext-bv1-ult-sext, commuted comparison)
(set-logic PBV)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) 1))
(assert (< 1 wt))
(assert (not (= (ite (pbvugt (psign_extend (- wt 1) c) (pzero_extend (- wt 1) c)) (int_to_pbv 1 1) (int_to_pbv 1 0)) c)))
(check-sat)
