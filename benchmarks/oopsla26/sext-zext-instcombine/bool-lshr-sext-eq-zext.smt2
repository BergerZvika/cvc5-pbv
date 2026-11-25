; ∀ (x : BitVec 1) (wt : Int), 1 ≤ wt →
;   signExtend wt x >>> (wt - 1) = zeroExtend wt x
; From: bool_zext_thm (x : BitVec 1), concrete width 16, shift 15
(set-logic PBV)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(assert (<= 1 wt))
(assert (not (= (pbvlshr (psign_extend (- wt 1) x) (int_to_pbv wt (- wt 1))) (pzero_extend (- wt 1) x))))
(check-sat)
