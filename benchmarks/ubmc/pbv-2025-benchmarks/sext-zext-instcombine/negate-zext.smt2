; ∀ (x : BitVec 1) (x1 : BitVec wa), 1 ≤ wa →
;   x1 - zeroExtend wa x = x1 + signExtend wa x
; From: negate_zext_thm (x : BitVec 1) (x_1 : BitVec 8), concrete wa=8
(set-logic PBV)
(declare-const wa Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(declare-const x1 PBitVec)
(assert (= (pbvsize x1) wa))
(assert (<= 1 wa))
(assert (not (= (pbvsub x1 (pzero_extend (- wa 1) x)) (pbvadd x1 (psign_extend (- wa 1) x)))))
(check-sat)
