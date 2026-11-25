(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvshl s (pbvlshr s (pbvshl s s))) (pbvurem s (pbvshl s (pbvshl s s)))))
(check-sat)
