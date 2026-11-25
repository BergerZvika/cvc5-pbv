; ∀ (x : BitVec wa) (wt : Int), wa < wt →
;   zeroExtend wt (truncate wa (zeroExtend wt x)) = zeroExtend wt x
; (trunc(zext(x))=x, then zext(x) again = zext(x))
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wt))
(assert (not (= (pzero_extend (- wt wa) (pextract (pzero_extend (- wt wa) x) (- wa 1) 0)) (pzero_extend (- wt wa) x))))
(check-sat)
