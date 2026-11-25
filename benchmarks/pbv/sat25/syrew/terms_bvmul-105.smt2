(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvlshr (pbvmul s s) s)) (pbvshl s (pbvshl s (pbvshl s s)))))
(check-sat)
