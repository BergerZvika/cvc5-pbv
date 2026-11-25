; forall (x : BitVec 1) (wt : Int), 1 <= wt ->
;   zeroExtend wt x &&& 1 = zeroExtend wt x
; From: zext_and1_thm: 1-bit zero-extended value AND 1 is itself (high bits are 0)
(set-logic PBV)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(assert (<= 1 wt))
(assert (not (= (pbvand (pzero_extend (- wt 1) x) (int_to_pbv wt 1)) (pzero_extend (- wt 1) x))))
(check-sat)
