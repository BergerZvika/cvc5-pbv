; ∀ (x : BitVec wa) (wt : Int), wa < wt →
;   zeroExtend wt (bvnot x) = lowmask(wa,wt) ^^^ zeroExtend wt x
; (bvnot x in wa bits; zext gives high-zero result; lowmask ^^^ zext(x) flips low bits)
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wt))
(assert (not (= (pzero_extend (- wt wa) (pbvnot x)) (pbvxor (pzero_extend (- wt wa) (pbvnot (int_to_pbv wa 0))) (pzero_extend (- wt wa) x)))))
(check-sat)
