; forall (x : BitVec wa) (y : BitVec wt), wa < wt ->
;   zeroExtend wt x ||| y = y ||| zeroExtend wt x
; From: zext_or_comm_thm: OR is commutative (via zext)
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(declare-const y PBitVec)
(assert (= (pbvsize y) wt))
(assert (< wa wt))
(assert (not (= (pbvor (pzero_extend (- wt wa) x) y) (pbvor y (pzero_extend (- wt wa) x)))))
(check-sat)
