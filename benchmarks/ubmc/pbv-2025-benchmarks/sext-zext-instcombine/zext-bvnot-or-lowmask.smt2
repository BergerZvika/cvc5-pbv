; ∀ (x : BitVec wa) (wt : Int), wa < wt →
;   zeroExtend wt (bvnot x) ||| zeroExtend wt x = lowmask
; (bvnot(x) ||| x = allones in wa bits; zext gives lowmask)
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wt))
(assert (not (= (pbvor (pzero_extend (- wt wa) (pbvnot x)) (pzero_extend (- wt wa) x)) (pzero_extend (- wt wa) (pbvnot (int_to_pbv wa 0))))))
(check-sat)
