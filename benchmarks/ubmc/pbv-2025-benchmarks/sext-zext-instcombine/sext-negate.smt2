; ∀ (x : BitVec 1) (wa : Int), 1 ≤ wa →
;   0#wa - signExtend wa x = zeroExtend wa x
; From: sext_negate_thm (x : BitVec 1), concrete wa=64
(set-logic PBV)
(declare-const wa Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(assert (<= 1 wa))
(assert (not (= (pbvsub (int_to_pbv wa 0) (psign_extend (- wa 1) x)) (pzero_extend (- wa 1) x))))
(check-sat)
