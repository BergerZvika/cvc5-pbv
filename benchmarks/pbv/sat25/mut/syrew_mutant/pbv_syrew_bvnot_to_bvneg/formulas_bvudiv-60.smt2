(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvudiv s (pbvneg s))) (= s (pbvudiv s (pbvnot s)))))
(check-sat)
