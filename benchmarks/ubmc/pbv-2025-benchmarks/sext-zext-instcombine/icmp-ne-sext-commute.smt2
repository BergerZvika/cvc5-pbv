; ∀ (x : BitVec w1) (y : BitVec w2) (w2 : Int), w1 < w2 →
;   ofBool (signExtend w2 x != y) = ofBool (y != signExtend w2 x)
; From: icmp_ne_sext_sgt_zero_nofold_thm (x : BitVec 32), concrete w1=1 w2=32
(set-logic PBV)
(declare-const w1 Int)
(declare-const w2 Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) w1))
(declare-const y PBitVec)
(assert (= (pbvsize y) w2))
(assert (< w1 w2))
(assert (not (= (ite (distinct (psign_extend (- w2 w1) x) y) (int_to_pbv 1 1) (int_to_pbv 1 0)) (ite (distinct y (psign_extend (- w2 w1) x)) (int_to_pbv 1 1) (int_to_pbv 1 0)))))
(check-sat)
