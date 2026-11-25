; forall (x x1 : BitVec 1) (wt : Int), 1 < wt ->
;   ofBool (-2 <s zeroExtend wt x1 + signExtend wt x) = 1
; From: zext_sext_add_sgt_neg2_true_thm: sum>=-1>-2 always, so -2<s sum is always true
(set-logic PBV)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(declare-const x1 PBitVec)
(assert (= (pbvsize x1) 1))
(assert (< 1 wt))
(assert (not (= (ite (pbvslt (pbvsub (pbvnot (int_to_pbv wt 0)) (int_to_pbv wt 1)) (pbvadd (pzero_extend (- wt 1) x1) (psign_extend (- wt 1) x))) (int_to_pbv 1 1) (int_to_pbv 1 0)) (int_to_pbv 1 1))))
(check-sat)
