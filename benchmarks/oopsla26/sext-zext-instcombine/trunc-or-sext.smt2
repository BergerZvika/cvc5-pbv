; ∀ (x : BitVec wa) (y : BitVec wt), wa < wt →
;   truncate wa (signExtend wt x ||| y) = x ||| truncate wa y
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(declare-const y PBitVec)
(assert (= (pbvsize y) wt))
(assert (< wa wt))
(assert (not (= (pextract (pbvor (psign_extend (- wt wa) x) y) (- wa 1) 0) (pbvor x (pextract y (- wa 1) 0)))))
(check-sat)
