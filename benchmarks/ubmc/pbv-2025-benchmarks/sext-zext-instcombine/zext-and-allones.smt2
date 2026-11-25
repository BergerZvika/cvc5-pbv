; forall (x : BitVec wa), wa < wt ->
;   zeroExtend wt x &&& bvnot(0) = zeroExtend wt x
; From: zext_and_allones_thm: AND-ing with all-ones mask in low bits is identity
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wt))
(assert (not (= (pbvand (pzero_extend (- wt wa) x) (pzero_extend (- wt wa) (pbvnot (int_to_pbv wa 0)))) (pzero_extend (- wt wa) x))))
(check-sat)
