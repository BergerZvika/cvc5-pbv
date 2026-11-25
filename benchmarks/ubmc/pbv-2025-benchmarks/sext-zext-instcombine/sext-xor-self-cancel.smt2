; ∀ (c : BitVec 1) (x : BitVec wt) (wt : Int), 1 < wt →
;   signExtend wt c ^^^ x ^^^ signExtend wt c = x
; (XOR is its own inverse: a ^^^ b ^^^ a = b)
(set-logic PBV)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) 1))
(declare-const x PBitVec)
(assert (= (pbvsize x) wt))
(assert (< 1 wt))
(assert (not (= (pbvxor (pbvxor (psign_extend (- wt 1) c) x) (psign_extend (- wt 1) c)) x)))
(check-sat)
