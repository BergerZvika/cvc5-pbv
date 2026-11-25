(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvshl s (pbvudiv s (pbvshl s s))) (pbvshl s (pbvlshr s (pbvshl s s)))))
(check-sat)
