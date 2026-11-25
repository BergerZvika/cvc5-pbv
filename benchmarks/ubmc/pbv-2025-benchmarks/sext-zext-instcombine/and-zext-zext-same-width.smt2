; forall (x y : BitVec wa), wa < wt ->
;   zeroExtend wt x &&& zeroExtend wt y = zeroExtend wt (x &&& y)
; From: and_zext_zext_same_width_thm: AND distributes into zext for same-width operands
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(declare-const y PBitVec)
(assert (= (pbvsize y) wa))
(assert (< wa wt))
(assert (not (= (pbvand (pzero_extend (- wt wa) x) (pzero_extend (- wt wa) y)) (pzero_extend (- wt wa) (pbvand x y)))))
(check-sat)
