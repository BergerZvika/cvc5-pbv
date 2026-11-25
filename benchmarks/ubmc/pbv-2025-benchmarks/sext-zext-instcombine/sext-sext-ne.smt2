; ∀ (x x1 : BitVec w) (wt : Int), w < wt →
;   ofBool (signExtend wt x1 != signExtend wt x) = ofBool (x1 != x)
; From: sext_sext_ne_thm (x x_1 : BitVec 8), concrete wt=32
(set-logic PBV)
(declare-const w Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) w))
(declare-const x1 PBitVec)
(assert (= (pbvsize x1) w))
(assert (< w wt))
(assert (not (= (ite (distinct (psign_extend (- wt w) x1) (psign_extend (- wt w) x)) (int_to_pbv 1 1) (int_to_pbv 1 0)) (ite (distinct x1 x) (int_to_pbv 1 1) (int_to_pbv 1 0)))))
(check-sat)
