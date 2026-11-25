(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvshl (pbvshl s s) s)) (pbvshl (pbvshl s s) s)))
(check-sat)
