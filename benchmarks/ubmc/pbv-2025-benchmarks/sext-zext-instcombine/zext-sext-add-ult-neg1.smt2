; forall (x x1 : BitVec 1) (wt : Int), 1 < wt ->
;   ofBool (zeroExtend wt x1 + signExtend wt x <u bvnot(0)) = x1 ||| (x ^^^ 1)
; From: zext_sext_add_ult_neg1_thm: sum<u(unsigned -1) iff sum in {0,1}
(set-logic PBV)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(declare-const x1 PBitVec)
(assert (= (pbvsize x1) 1))
(assert (< 1 wt))
(assert (not (= (ite (pbvult (pbvadd (pzero_extend (- wt 1) x1) (psign_extend (- wt 1) x)) (pbvnot (int_to_pbv wt 0))) (int_to_pbv 1 1) (int_to_pbv 1 0)) (pbvor x1 (pbvxor x (int_to_pbv 1 1))))))
(check-sat)
