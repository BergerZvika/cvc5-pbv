; ∀ (c : BitVec 1) (wt : Int), 1 < wt →
;   ofBool (zeroExtend wt c == signExtend wt c) = bvnot c
(set-logic PBV)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) 1))
(assert (< 1 wt))
(assert (not (= (ite (= (pzero_extend (- wt 1) c) (psign_extend (- wt 1) c)) (int_to_pbv 1 1) (int_to_pbv 1 0)) (pbvnot c))))
(check-sat)
