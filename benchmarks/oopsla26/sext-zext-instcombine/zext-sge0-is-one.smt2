; ∀ (x : BitVec wa) (wt : Int), wa < wt →
;   ofBool (zeroExtend wt x ≥ₛ 0) = 1#1
; (zext is always nonneg signed)
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wt))
(assert (not (= (ite (pbvsge (pzero_extend (- wt wa) x) (int_to_pbv wt 0)) (int_to_pbv 1 1) (int_to_pbv 1 0)) (int_to_pbv 1 1))))
(check-sat)
