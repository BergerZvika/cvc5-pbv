; ∀ (x y : BitVec wa) (wt : Int), wa < wt →
;   truncate wa (zeroExtend wt x + zeroExtend wt y) = x + y
; (test1_thm generalized)
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
