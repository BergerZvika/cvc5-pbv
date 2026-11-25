; ∀ (x y : BitVec wa) (wt : Int), wa < wt →
;   truncate wa (signExtend wt x + signExtend wt y) = x + y
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(declare-const y PBitVec)
(assert (= (pbvsize y) wa))
(assert (< wa wt))
(assert (not (= (pextract (pbvadd (psign_extend (- wt wa) x) (psign_extend (- wt wa) y)) (- wa 1) 0) (pbvadd x y))))
(check-sat)
