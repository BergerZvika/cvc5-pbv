; ∀ (x y : BitVec wa) (wt : Int), wa < wt →
;   truncate wa (zeroExtend wt x + bvnot (zeroExtend wt y)) = x + bvnot y
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(declare-const y PBitVec)
(assert (= (pbvsize y) wa))
(assert (< wa wt))
(assert (not (= (pextract (pbvadd (pzero_extend (- wt wa) x) (pbvnot (pzero_extend (- wt wa) y))) (- wa 1) 0) (pbvadd x (pbvnot y)))))
(check-sat)
