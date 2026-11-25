; ∀ (x : BitVec wa) (wm wt : Int), wa < wm → wm < wt →
;   zeroExtend wt (zeroExtend wm x) = zeroExtend wt x
(set-logic PBV)
(declare-const wa Int)
(declare-const wm Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wm))
(assert (< wm wt))
(assert (not (= (pzero_extend (- wt wm) (pzero_extend (- wm wa) x)) (pzero_extend (- wt wa) x))))
(check-sat)
