; forall (x : BitVec wa), wa < wt ->
;   signExtend wt x &&& signExtend wt (bvnot 0) = signExtend wt x
; From: sext_and_allones_thm: sext(-1) = all-ones, AND with it is identity
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wt))
(assert (not (= (pbvand (psign_extend (- wt wa) x) (psign_extend (- wt wa) (pbvnot (int_to_pbv wa 0)))) (psign_extend (- wt wa) x))))
(check-sat)
