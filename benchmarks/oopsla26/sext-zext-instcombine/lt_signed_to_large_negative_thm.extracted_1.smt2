; ∀ (x : BitVec 8), ofBool (BitVec.ofInt 32 (-1024) <ₛ signExtend 32 x) = 1#1
; -1024 = -2^w10 is always <ₛ the minimum signed w8-bit value sign-extended to w32 bits.
; So the signed comparison is always true.
(set-logic PBV)
(declare-const w8 Int)
(declare-const w32 Int)
(declare-const w10 Int)
(assert (< w8 w10))
(assert (< w10 w32))
(declare-const x PBitVec)
(assert (= (pbvsize x) w8))
(assert (not (pbvslt (pbvshl (pbvneg (int_to_pbv w32 1)) (int_to_pbv w32 w10)) (psign_extend (- w32 w8) x))))
(check-sat)
