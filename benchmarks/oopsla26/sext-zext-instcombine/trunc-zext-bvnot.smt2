; ∀ (x : BitVec wa) (wt : Int), wa < wt →
;   truncate wa (bvnot (zeroExtend wt x)) = bvnot x
; (bvnot(zext(x)) = bvnot in high bits too, but trunc discards them)
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wt))
(assert (not (= (pextract (pbvnot (pzero_extend (- wt wa) x)) (- wa 1) 0) (pbvnot x))))
(check-sat)
