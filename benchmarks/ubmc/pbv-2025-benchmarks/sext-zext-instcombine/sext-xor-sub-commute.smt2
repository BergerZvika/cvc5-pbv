; ∀ (x1 : BitVec w1) (y : BitVec wt), w1 < wt →
;   (signExtend wt x1 ^^^ y) - signExtend wt x1 = (y ^^^ signExtend wt x1) - signExtend wt x1
; From: sext_non_bool_xor_sub_1_thm (x : BitVec 64) (x_1 : BitVec 8), concrete w1=8 wt=64
(set-logic PBV)
(declare-const w1 Int)
(declare-const wt Int)
(declare-const x1 PBitVec)
(assert (= (pbvsize x1) w1))
(declare-const y PBitVec)
(assert (= (pbvsize y) wt))
(assert (< w1 wt))
(assert (not (= (pbvsub (pbvxor (psign_extend (- wt w1) x1) y) (psign_extend (- wt w1) x1)) (pbvsub (pbvxor y (psign_extend (- wt w1) x1)) (psign_extend (- wt w1) x1)))))
(check-sat)
