(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvshl (pbvmul s s) s)) (pbvult s (pbvmul s (pbvshl s s)))))
(check-sat)
