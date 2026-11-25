(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvurem s (pbvlshr s s))) (= s s)))
(check-sat)
