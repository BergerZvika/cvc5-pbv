; forall (x x1 : BitVec 1) (wt : Int), 2 < wt ->
;   ofBool (zeroExtend wt x1 + signExtend wt x <s 2) = 1
; sum in {-1,0,1} <= 1 < 2 (requires wt>2 so int_to_pbv wt 2 = signed +2)
; From: zext_sext_add_slt_2_true_thm: sum<s2 is always true
(set-logic PBV)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(declare-const x1 PBitVec)
(assert (= (pbvsize x1) 1))
(assert (< 2 wt))
(assert (not (= (ite (pbvslt (pbvadd (pzero_extend (- wt 1) x1) (psign_extend (- wt 1) x)) (int_to_pbv wt 2)) (int_to_pbv 1 1) (int_to_pbv 1 0)) (int_to_pbv 1 1))))
(check-sat)
