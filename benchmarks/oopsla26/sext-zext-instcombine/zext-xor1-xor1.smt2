; forall (x : BitVec 1) (wt : Int), 1 <= wt ->
;   zeroExtend wt (x ^^^ 1) ^^^ 1 = zeroExtend wt x
; From: zext_xor1_xor1_thm: double-XOR with 1 is identity for 1-bit zero-extended value
(set-logic PBV)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(assert (<= 1 wt))
(assert (not (= (pbvxor (pzero_extend (- wt 1) (pbvxor x (int_to_pbv 1 1))) (int_to_pbv wt 1)) (pzero_extend (- wt 1) x))))
(check-sat)
