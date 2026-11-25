; ∀ (x : BitVec w4) (x_1 : BitVec w7),
;   ofBool (signExtend w25 x_1 == signExtend w25 x) = ofBool (x_1 == signExtend w7 x)
; Comparing two sign-extended values at a larger width is equivalent to
; sign-extending the narrower one to the wider one's width and comparing there.
(set-logic PBV)
(declare-const w4 Int)
(declare-const w7 Int)
(declare-const w25 Int)
(assert (<= w4 w7))
(assert (<= w7 w25))
(declare-const x1 PBitVec)
(assert (= (pbvsize x1) w7))
(declare-const x PBitVec)
(assert (= (pbvsize x) w4))
(assert (not (= (= (psign_extend (- w25 w7) x1) (psign_extend (- w25 w4) x)) (= x1 (psign_extend (- w7 w4) x)))))
(check-sat)
