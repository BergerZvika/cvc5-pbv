; ∀ (c : BitVec 1) (x : BitVec wt) (wt : Int), 1 < wt →
;   zeroExtend wt c * x = signExtend wt c &&& x
; (c=0: 0*x=0=0&&&x; c=1: 1*x=x=-1&&&x=x)
(set-logic PBV)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) 1))
(declare-const x PBitVec)
(assert (= (pbvsize x) wt))
(assert (< 1 wt))
(assert (not (= (pbvmul (pzero_extend (- wt 1) c) x) (pbvand (psign_extend (- wt 1) c) x))))
(check-sat)
