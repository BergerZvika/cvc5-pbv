; ∀ (x y : BitVec wa) (wt : Int), wa < wt →
;   signExtend wt (x ^^^ y) = signExtend wt x ^^^ signExtend wt y
; (XOR is bit-local; sext distributes through XOR)
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(declare-const y PBitVec)
(assert (= (pbvsize y) wa))
(assert (< wa wt))
(assert (not (= (psign_extend (- wt wa) (pbvxor x y)) (pbvxor (psign_extend (- wt wa) x) (psign_extend (- wt wa) y)))))
(check-sat)
