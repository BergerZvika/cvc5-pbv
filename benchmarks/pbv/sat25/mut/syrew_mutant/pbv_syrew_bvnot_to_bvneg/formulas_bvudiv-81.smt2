(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvshl s (pbvudiv s s))) (pbvult s (pbvneg s))))
(check-sat)
