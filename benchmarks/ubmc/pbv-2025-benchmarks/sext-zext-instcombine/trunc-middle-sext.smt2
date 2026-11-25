; test18_thm (truncate of wider sext)
; ∀ (x : BitVec wa) (wm wt : Int), wa < wm → wm < wt →
;   truncate wm (signExtend wt x) = signExtend wm x
(set-logic PBV)
(declare-const wa Int)
(declare-const wm Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wm))
(assert (< wm wt))
(assert (not (= (pextract (psign_extend (- wt wa) x) (- wm 1) 0) (psign_extend (- wm wa) x))))
(check-sat)
