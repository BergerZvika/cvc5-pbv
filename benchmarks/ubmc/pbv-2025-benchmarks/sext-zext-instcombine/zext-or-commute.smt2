; ∀ (x y : BitVec wa) (wt : Int), wa < wt →
;   zeroExtend wt (x ||| y) = zeroExtend wt x ||| zeroExtend wt y
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(declare-const y PBitVec)
(assert (= (pbvsize y) wa))
(assert (< wa wt))
(assert (not (= (pzero_extend (- wt wa) (pbvor x y)) (pbvor (pzero_extend (- wt wa) x) (pzero_extend (- wt wa) y)))))
(check-sat)
