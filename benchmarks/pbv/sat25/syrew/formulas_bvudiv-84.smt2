(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvudiv s (pbvudiv s s))) (distinct s s)))
(check-sat)
