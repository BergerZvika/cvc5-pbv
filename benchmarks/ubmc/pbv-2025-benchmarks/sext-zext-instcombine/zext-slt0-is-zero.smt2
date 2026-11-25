; ∀ (x : BitVec wa) (wt : Int), wa < wt →
;   ofBool (zeroExtend wt x <ₛ 0) = 0#1
; (zext always has 0 in the sign bit, so it's always >= 0 signed)
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wt))
(assert (not (= (ite (pbvslt (pzero_extend (- wt wa) x) (int_to_pbv wt 0)) (int_to_pbv 1 1) (int_to_pbv 1 0)) (int_to_pbv 1 0))))
(check-sat)
