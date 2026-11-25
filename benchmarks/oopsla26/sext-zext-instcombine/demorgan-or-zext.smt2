; ∀ (x x1 : BitVec 1) (wt : Int), 1 ≤ wt →
;   zeroExtend wt x1 ^^^ 1#wt ||| zeroExtend wt x ^^^ 1#wt = zeroExtend wt (x1 &&& x ^^^ 1#1)
; From: demorgan_or_zext_thm (x x_1 : BitVec 1), concrete width 32
(set-logic PBV)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(declare-const x1 PBitVec)
(assert (= (pbvsize x1) 1))
(assert (<= 1 wt))
(assert (not (= (pbvor (pbvxor (pzero_extend (- wt 1) x1) (int_to_pbv wt 1)) (pbvxor (pzero_extend (- wt 1) x) (int_to_pbv wt 1))) (pzero_extend (- wt 1) (pbvxor (pbvand x1 x) (int_to_pbv 1 1))))))
(check-sat)
