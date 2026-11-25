; forall (x x1 : BitVec 1) (wt : Int), 1 <= wt ->
;   ofBool (zeroExtend wt x1 == zeroExtend wt x) = x1 ^^^ x ^^^ 1
; From: zext_bv1_xnor_thm: equality of zero-extended 1-bits is XNOR
(set-logic PBV)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(declare-const x1 PBitVec)
(assert (= (pbvsize x1) 1))
(assert (<= 1 wt))
(assert (not (= (ite (= (pzero_extend (- wt 1) x1) (pzero_extend (- wt 1) x)) (int_to_pbv 1 1) (int_to_pbv 1 0)) (pbvxor (pbvxor x1 x) (int_to_pbv 1 1)))))
(check-sat)
