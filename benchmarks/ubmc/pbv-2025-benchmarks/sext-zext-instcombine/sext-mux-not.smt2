; ∀ (c : BitVec 1) (x y : BitVec wt) (wt : Int), 1 < wt →
;   bvnot(signExtend wt c) &&& x ||| signExtend wt c &&& y
;   = ite(c = 1, y, x)
(set-logic PBV)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) 1))
(declare-const x PBitVec)
(assert (= (pbvsize x) wt))
(declare-const y PBitVec)
(assert (= (pbvsize y) wt))
(assert (< 1 wt))
(assert (not (= (pbvor (pbvand (pbvnot (psign_extend (- wt 1) c)) x) (pbvand (psign_extend (- wt 1) c) y)) (ite (= c (int_to_pbv 1 1)) y x))))
(check-sat)
