; ∀ (x : BitVec wa) (wt : Int), wa < wt →
;   truncate wa (bvnot (signExtend wt x)) = bvnot x
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wt))
(assert (not (= (pextract (pbvnot (psign_extend (- wt wa) x)) (- wa 1) 0) (pbvnot x))))
(check-sat)
