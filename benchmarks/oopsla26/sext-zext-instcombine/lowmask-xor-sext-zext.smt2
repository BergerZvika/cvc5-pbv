; ∀ (x : BitVec wa) (wt : Int), wa < wt →
;   (signExtend wt x ^^^ zeroExtend wt x) &&& lowmask(wa,wt) = 0
; (sext and zext agree on low bits; XOR of equal things = 0; mask zeroes high)
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wt))
(assert (not (= (pbvand (pbvxor (psign_extend (- wt wa) x) (pzero_extend (- wt wa) x)) (pzero_extend (- wt wa) (pbvnot (int_to_pbv wa 0)))) (int_to_pbv wt 0))))
(check-sat)
