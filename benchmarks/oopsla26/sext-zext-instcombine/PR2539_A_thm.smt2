; ∀ (x : BitVec 1), ofBool (zeroExtend w32 x <ₛ 1#w32) = x ^^^ 1#1
; ofBool converts Bool to BitVec 1: true → 1, false → 0.
; zeroExtend w32 x adds (w32 - 1) zero bits to x (a 1-bit value).
(set-logic PBV)
(declare-const w32 Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(assert (> w32 1))
(assert (not (= (ite (pbvslt (pzero_extend (- w32 1) x) (int_to_pbv w32 1)) (int_to_pbv 1 1) (int_to_pbv 1 0)) (pbvxor x (int_to_pbv 1 1)))))
(check-sat)
