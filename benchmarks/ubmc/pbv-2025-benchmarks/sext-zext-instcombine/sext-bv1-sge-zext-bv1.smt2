; ∀ (c : BitVec 1) (wt : Int), 1 < wt →
;   ofBool (signExtend wt c >=ₛ zeroExtend wt c) = bvnot c
; (c=0: 0 >=s 0 = true → 1 = bvnot(0) ✓; c=1: -1 >=s 1 = false → 0 = bvnot(1) ✓)
(set-logic PBV)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) 1))
(assert (< 1 wt))
(assert (not (= (ite (pbvsge (psign_extend (- wt 1) c) (pzero_extend (- wt 1) c)) (int_to_pbv 1 1) (int_to_pbv 1 0)) (pbvnot c))))
(check-sat)
