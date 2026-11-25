(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvlshr s (pbvshl s s))) (pbvurem s (pbvshl s (pbvshl s s)))))
(check-sat)
