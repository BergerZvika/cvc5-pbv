; test17_thm (truncate of wider zext)
; ∀ (x : BitVec wa) (wm wt : Int), wa < wm → wm < wt →
;   truncate wm (zeroExtend wt x) = zeroExtend wm x
(set-logic PBV)
(declare-const wa Int)
(declare-const wm Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wm))
(assert (< wm wt))
(assert (not (= (pextract (pzero_extend (- wt wa) x) (- wm 1) 0) (pzero_extend (- wm wa) x))))
(check-sat)
