(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvurem s (pbvshl s s))) (= s s)))
(check-sat)
