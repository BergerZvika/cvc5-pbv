(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr (pbvmul s s) (pbvshl s s)) (pbvmul s (pbvlshr s (pbvshl s s)))))
(check-sat)
