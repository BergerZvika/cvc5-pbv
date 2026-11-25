; ∀ (x : BitVec wa) (wm wt : Int), wa < wm → wm < wt →
;   signExtend wt (signExtend wm x) = signExtend wt x
; (sign-extending twice = sign-extending once to the final width)
(set-logic PBV)
(declare-const wa Int)
(declare-const wm Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wm))
(assert (< wm wt))
(assert (not (= (psign_extend (- wt wm) (psign_extend (- wm wa) x)) (psign_extend (- wt wa) x))))
(check-sat)
