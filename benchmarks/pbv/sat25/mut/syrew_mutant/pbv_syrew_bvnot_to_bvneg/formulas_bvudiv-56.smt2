(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvshl s (pbvneg s))) (= s (pbvnot (pbvudiv (int_to_pbv (pbvsize s) 0) s)))))
(check-sat)
