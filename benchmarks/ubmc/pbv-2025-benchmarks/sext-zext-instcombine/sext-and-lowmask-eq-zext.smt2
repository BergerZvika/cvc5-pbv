; ∀ (x : BitVec wa) (wt : Int), wa < wt →
;   signExtend wt x &&& lowmask(wa,wt) = zeroExtend wt x
; (high bits of sext are zeroed by the mask, leaving just the low wa bits = zext)
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wt))
(assert (not (= (pbvand (psign_extend (- wt wa) x) (pzero_extend (- wt wa) (pbvnot (int_to_pbv wa 0)))) (pzero_extend (- wt wa) x))))
(check-sat)
