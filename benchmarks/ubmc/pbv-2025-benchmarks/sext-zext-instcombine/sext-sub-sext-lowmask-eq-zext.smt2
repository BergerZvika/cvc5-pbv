; ∀ (x y : BitVec wa) (wt : Int), wa < wt →
;   (signExtend wt x - signExtend wt y) &&& lowmask
;   = (zeroExtend wt x - zeroExtend wt y) &&& lowmask
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(declare-const y PBitVec)
(assert (= (pbvsize y) wa))
(assert (< wa wt))
(assert (not (= (pbvand (pbvsub (psign_extend (- wt wa) x) (psign_extend (- wt wa) y)) (pzero_extend (- wt wa) (pbvnot (int_to_pbv wa 0)))) (pbvand (pbvsub (pzero_extend (- wt wa) x) (pzero_extend (- wt wa) y)) (pzero_extend (- wt wa) (pbvnot (int_to_pbv wa 0)))))))
(check-sat)
