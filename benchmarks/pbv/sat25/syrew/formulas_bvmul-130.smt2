(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvshl (pbvmul s s) s)) (pbvule s (pbvmul s (pbvshl s s)))))
(check-sat)
