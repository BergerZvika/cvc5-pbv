; ∀ (x : BitVec wa) (y : BitVec 1) (wt : Int), wa < wt → 1 < wt →
;   ofBool (zeroExtend wt x <ₛ signExtend wt y) = 0#1
; (zext is always nonneg; sext of bv1 is 0 or -1; nonneg <s -1 is false; nonneg <s 0 is false)
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(declare-const y PBitVec)
(assert (= (pbvsize y) 1))
(assert (< wa wt))
(assert (< 1 wt))
(assert (not (= (ite (pbvslt (pzero_extend (- wt wa) x) (psign_extend (- wt 1) y)) (int_to_pbv 1 1) (int_to_pbv 1 0)) (int_to_pbv 1 0))))
(check-sat)
