; ∀ (x x1 : BitVec 1) (wt : Int), 2 ≤ wt →
;   (zeroExtend wt x1 + zeroExtend wt x) >>> 1 = zeroExtend wt (x1 &&& x)
; From: bool_add_lshr_thm (x x_1 : BitVec 1), concrete width 2
(set-logic PBV)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(declare-const x1 PBitVec)
(assert (= (pbvsize x1) 1))
(assert (<= 2 wt))
(assert (not (= (pbvlshr (pbvadd (pzero_extend (- wt 1) x1) (pzero_extend (- wt 1) x)) (int_to_pbv wt 1)) (pzero_extend (- wt 1) (pbvand x1 x)))))
(check-sat)
