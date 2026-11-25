(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvudiv s (pbvneg s))) (pbvult s (pbvnot (pbvudiv s s)))))
(check-sat)
