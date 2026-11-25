(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvurem s (pbvlshr s s))) (distinct s s)))
(check-sat)
