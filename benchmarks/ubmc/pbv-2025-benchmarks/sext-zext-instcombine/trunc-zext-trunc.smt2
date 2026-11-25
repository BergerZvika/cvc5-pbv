; ∀ (x : BitVec wt) (wa wm : Int), wa < wm → wm < wt →
;   truncate wa (zeroExtend wt (truncate wm x)) = truncate wa x
(set-logic PBV)
(declare-const wa Int)
(declare-const wm Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wt))
(assert (< wa wm))
(assert (< wm wt))
(assert (not (= (pextract (pzero_extend (- wt wm) (pextract x (- wm 1) 0)) (- wa 1) 0) (pextract x (- wa 1) 0))))
(check-sat)
