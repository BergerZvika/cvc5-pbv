; forall (x y : BitVec wa), wa < wt ->
;   ofBool (zeroExtend wt x <=s zeroExtend wt y) = ofBool (x <=u y)
; From: zext_zext_sle_same_thm: signed <= of zero-extends equals unsigned <=
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(declare-const y PBitVec)
(assert (= (pbvsize y) wa))
(assert (< wa wt))
(assert (not (= (ite (pbvsle (pzero_extend (- wt wa) x) (pzero_extend (- wt wa) y)) (int_to_pbv 1 1) (int_to_pbv 1 0)) (ite (pbvule x y) (int_to_pbv 1 1) (int_to_pbv 1 0)))))
(check-sat)
