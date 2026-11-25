; ∀ (c : BitVec 1) (wt : Int), 1 < wt →
;   zeroExtend wt c &&& signExtend wt c = zeroExtend wt c
; (c=0: 0&&&0=0; c=1: 1&&&-1=1)
(set-logic PBV)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) 1))
(assert (< 1 wt))
(assert (not (= (pbvand (pzero_extend (- wt 1) c) (psign_extend (- wt 1) c)) (pzero_extend (- wt 1) c))))
(check-sat)
