(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvurem s (pbvshl s s))) (distinct s s)))
(check-sat)
