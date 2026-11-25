; forall (x x1 : BitVec 1) (wt : Int), 1 < wt ->
;   ofBool (0 <s zeroExtend wt x1 + signExtend wt x) = x1 &&& (x ^^^ 1)
; From: zext_sext_add_sgt_0_thm: sum>s0 iff sum=1 iff x1=1,x=0
(set-logic PBV)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(declare-const x1 PBitVec)
(assert (= (pbvsize x1) 1))
(assert (< 1 wt))
(assert (not (= (ite (pbvslt (int_to_pbv wt 0) (pbvadd (pzero_extend (- wt 1) x1) (psign_extend (- wt 1) x))) (int_to_pbv 1 1) (int_to_pbv 1 0)) (pbvand x1 (pbvxor x (int_to_pbv 1 1))))))
(check-sat)
