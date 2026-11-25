; forall (x : BitVec 1) (wt : Int), 1 <= wt ->
;   ofBool (zeroExtend wt x <=s signExtend wt x) = x ^^^ 1
; From: zext_le_sext_bv1_thm: zext <=s sext only when x=0 (when x=1: 1 <=s -1 is false)
(set-logic PBV)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(assert (<= 1 wt))
(assert (not (= (ite (pbvsle (pzero_extend (- wt 1) x) (psign_extend (- wt 1) x)) (int_to_pbv 1 1) (int_to_pbv 1 0)) (pbvxor x (int_to_pbv 1 1)))))
(check-sat)
