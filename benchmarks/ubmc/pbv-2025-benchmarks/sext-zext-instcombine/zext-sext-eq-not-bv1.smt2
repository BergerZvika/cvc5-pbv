; forall (x : BitVec 1) (wt : Int), 1 <= wt ->
;   ofBool (zeroExtend wt x == signExtend wt x) = x ^^^ 1
; From: zext_sext_eq_not_bv1_thm: zext and sext of 1-bit are equal iff bit is 0
(set-logic PBV)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(assert (<= 1 wt))
(assert (not (= (ite (= (pzero_extend (- wt 1) x) (psign_extend (- wt 1) x)) (int_to_pbv 1 1) (int_to_pbv 1 0)) (pbvxor x (int_to_pbv 1 1)))))
(check-sat)
