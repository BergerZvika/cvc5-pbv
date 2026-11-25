; ∀ (x : BitVec wa) (wt : Int), wa < wt →
;   (signExtend wt x ||| zeroExtend wt x) &&& lowmask(wa,wt) = zeroExtend wt x
; (sext and zext agree on low bits; OR doesn't change them; mask zeroes high bits)
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wt))
(assert (not (= (pbvand (pbvor (psign_extend (- wt wa) x) (pzero_extend (- wt wa) x)) (pzero_extend (- wt wa) (pbvnot (int_to_pbv wa 0)))) (pzero_extend (- wt wa) x))))
(check-sat)
