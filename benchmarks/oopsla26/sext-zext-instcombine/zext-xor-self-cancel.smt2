; ∀ (c : BitVec wa) (x : BitVec wt) (wt wa : Int), wa < wt →
;   zeroExtend wt c ^^^ x ^^^ zeroExtend wt c = x
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) wa))
(declare-const x PBitVec)
(assert (= (pbvsize x) wt))
(assert (< wa wt))
(assert (not (= (pbvxor (pbvxor (pzero_extend (- wt wa) c) x) (pzero_extend (- wt wa) c)) x)))
(check-sat)
