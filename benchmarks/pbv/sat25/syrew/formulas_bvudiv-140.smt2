(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvudiv s (pbvshl (int_to_pbv (pbvsize s) 1) s))) (= s (pbvnot (pbvudiv (int_to_pbv (pbvsize s) 0) s)))))
(check-sat)
