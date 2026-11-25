; forall (x : BitVec 1) (wt : Int), 1 <= wt ->
;   0#wt - zeroExtend wt x = signExtend wt x
; From: zext_negate_bv1_thm: negation of zero-extended 1-bit is sign-extended 1-bit
(set-logic PBV)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(assert (<= 1 wt))
(assert (not (= (pbvsub (int_to_pbv wt 0) (pzero_extend (- wt 1) x)) (psign_extend (- wt 1) x))))
(check-sat)
