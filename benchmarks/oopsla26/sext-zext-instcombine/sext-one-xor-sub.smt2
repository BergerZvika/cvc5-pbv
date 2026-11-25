; forall (y : BitVec wt), 1 <= wt ->
;   (y ^^^ signExtend wt 1#1) - signExtend wt 1#1 = -y
; sext(wt) of 1-bit 1 = all-ones = -1, so (y ^^^ -1) - (-1) = NOT(y) + 1 = -y
; From: sext_one_xor_sub_thm: XOR-then-subtract by sext(-1) is negation
(set-logic PBV)
(declare-const wt Int)
(declare-const y PBitVec)
(assert (= (pbvsize y) wt))
(assert (<= 1 wt))
(assert (not (= (pbvsub (pbvxor y (psign_extend (- wt 1) (int_to_pbv 1 1))) (psign_extend (- wt 1) (int_to_pbv 1 1))) (pbvneg y))))
(check-sat)
