; ∀ (x : BitVec wa) (wm wt : Int), wa < wm → wm < wt →
;   signExtend wt (zeroExtend wm x) = zeroExtend wt x
; (zext(wm)(x) has bit wm-1 = 0, so sext(wt)(zext(wm)(x)) extends with 0s = zext)
(set-logic PBV)
(declare-const wa Int)
(declare-const wm Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wm))
(assert (< wm wt))
(assert (not (= (psign_extend (- wt wm) (pzero_extend (- wm wa) x)) (pzero_extend (- wt wa) x))))
(check-sat)
