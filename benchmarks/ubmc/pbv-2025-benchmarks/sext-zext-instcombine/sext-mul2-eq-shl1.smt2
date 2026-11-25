; forall (x : BitVec wa), wa < wt ->
;   signExtend wt x * 2 = signExtend wt x <<< 1
; From: sext_mul2_eq_shl1_thm: multiply by 2 equals left shift by 1
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wt))
(assert (not (= (pbvmul (psign_extend (- wt wa) x) (int_to_pbv wt 2)) (pbvshl (psign_extend (- wt wa) x) (int_to_pbv wt 1)))))
(check-sat)
