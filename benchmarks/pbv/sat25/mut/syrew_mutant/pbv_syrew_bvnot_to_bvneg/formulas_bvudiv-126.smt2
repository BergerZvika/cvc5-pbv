(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvudiv s (pbvudiv (int_to_pbv (pbvsize s) 0) s))) (= s (pbvneg (pbvudiv (int_to_pbv (pbvsize s) 0) s)))))
(check-sat)
