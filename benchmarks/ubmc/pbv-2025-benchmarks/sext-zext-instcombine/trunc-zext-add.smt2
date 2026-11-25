; forall (x y : BitVec wa), wa < wt ->
;   truncate wa (zeroExtend wt x + zeroExtend wt y) = x + y
; From: trunc_zext_add_thm: modular addition preserved after zext and trunc
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(declare-const y PBitVec)
(assert (= (pbvsize y) wa))
(assert (< wa wt))
(assert (not (= (pextract (pbvadd (pzero_extend (- wt wa) x) (pzero_extend (- wt wa) y)) (- wa 1) 0) (pbvadd x y))))
(check-sat)
