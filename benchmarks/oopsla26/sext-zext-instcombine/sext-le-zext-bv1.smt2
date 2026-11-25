; forall (x : BitVec 1) (wt : Int), 1 <= wt ->
;   ofBool (signExtend wt x <=s zeroExtend wt x) = 1
; From: sext_le_zext_bv1_thm: sext always <= zext for 1-bit values (0->0=0, 1->-1<=1)
(set-logic PBV)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(assert (<= 1 wt))
(assert (not (= (ite (pbvsle (psign_extend (- wt 1) x) (pzero_extend (- wt 1) x)) (int_to_pbv 1 1) (int_to_pbv 1 0)) (int_to_pbv 1 1))))
(check-sat)
