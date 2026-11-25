(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvudiv s (pbvudiv s s))) (= s s)))
(check-sat)
