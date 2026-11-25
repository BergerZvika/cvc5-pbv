; ∀ (x : BitVec wa) (wt : Int), wa < wt →
;   signExtend wt (truncate wa (signExtend wt x)) = signExtend wt x
; (trunc(sext(x))=x, then sext(x) again = sext(x))
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wt))
(assert (not (= (psign_extend (- wt wa) (pextract (psign_extend (- wt wa) x) (- wa 1) 0)) (psign_extend (- wt wa) x))))
(check-sat)
