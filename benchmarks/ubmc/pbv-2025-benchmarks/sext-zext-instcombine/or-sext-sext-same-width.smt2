; forall (x y : BitVec wa), wa < wt ->
;   signExtend wt x ||| signExtend wt y = signExtend wt (x ||| y)
; From: or_sext_sext_same_width_thm: OR distributes into sext for same-width operands
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(declare-const y PBitVec)
(assert (= (pbvsize y) wa))
(assert (< wa wt))
(assert (not (= (pbvor (psign_extend (- wt wa) x) (psign_extend (- wt wa) y)) (psign_extend (- wt wa) (pbvor x y)))))
(check-sat)
