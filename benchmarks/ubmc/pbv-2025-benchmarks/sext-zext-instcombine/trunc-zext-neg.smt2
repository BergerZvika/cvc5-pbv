; ∀ (x : BitVec wa) (wt : Int), wa < wt →
;   truncate wa (bvneg (zeroExtend wt x)) = bvneg x
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wt))
(assert (not (= (pextract (pbvneg (pzero_extend (- wt wa) x)) (- wa 1) 0) (pbvneg x))))
(check-sat)
