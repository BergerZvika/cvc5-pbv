; forall (x x1 : BitVec 1) (wt : Int), 1 < wt ->
;   ofBool (zeroExtend wt x1 + signExtend wt x <s 0) = x &&& (x1 ^^^ 1)
; From: zext_sext_add_slt_0_thm: sum<s0 iff sum=-1 iff x1=0,x=1
(set-logic PBV)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(declare-const x1 PBitVec)
(assert (= (pbvsize x1) 1))
(assert (< 1 wt))
(assert (not (= (ite (pbvslt (pbvadd (pzero_extend (- wt 1) x1) (psign_extend (- wt 1) x)) (int_to_pbv wt 0)) (int_to_pbv 1 1) (int_to_pbv 1 0)) (pbvand x (pbvxor x1 (int_to_pbv 1 1))))))
(check-sat)
