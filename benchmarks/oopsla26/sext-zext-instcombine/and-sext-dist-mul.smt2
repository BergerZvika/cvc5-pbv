; ∀ (c : BitVec 1) (x y : BitVec wt) (wt : Int), 1 < wt →
;   signExtend wt c &&& (x * y) = (signExtend wt c &&& x) * y
(set-logic PBV)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) 1))
(declare-const x PBitVec)
(assert (= (pbvsize x) wt))
(declare-const y PBitVec)
(assert (= (pbvsize y) wt))
(assert (< 1 wt))
(assert (not (= (pbvand (psign_extend (- wt 1) c) (pbvmul x y)) (pbvmul (pbvand (psign_extend (- wt 1) c) x) y))))
(check-sat)
