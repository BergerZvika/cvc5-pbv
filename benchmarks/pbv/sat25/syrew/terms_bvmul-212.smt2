(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvshl (pbvshl s s) (pbvmul s s)) (pbvshl (pbvshl s s) s)))
(check-sat)
