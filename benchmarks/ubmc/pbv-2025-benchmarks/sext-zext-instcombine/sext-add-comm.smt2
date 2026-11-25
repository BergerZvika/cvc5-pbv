; forall (x : BitVec wa) (y : BitVec wt), wa < wt ->
;   signExtend wt x + y = y + signExtend wt x
; From: sext_add_comm_thm: addition is commutative (via sext)
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(declare-const y PBitVec)
(assert (= (pbvsize y) wt))
(assert (< wa wt))
(assert (not (= (pbvadd (psign_extend (- wt wa) x) y) (pbvadd y (psign_extend (- wt wa) x)))))
(check-sat)
