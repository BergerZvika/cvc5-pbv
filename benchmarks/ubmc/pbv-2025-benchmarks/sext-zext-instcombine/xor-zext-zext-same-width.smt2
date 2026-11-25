; forall (x y : BitVec wa), wa < wt ->
;   zeroExtend wt x ^^^ zeroExtend wt y = zeroExtend wt (x ^^^ y)
; From: xor_zext_zext_same_width_thm: XOR distributes into zext for same-width operands
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(declare-const y PBitVec)
(assert (= (pbvsize y) wa))
(assert (< wa wt))
(assert (not (= (pbvxor (pzero_extend (- wt wa) x) (pzero_extend (- wt wa) y)) (pzero_extend (- wt wa) (pbvxor x y)))))
(check-sat)
