(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvor s (pbvudiv (int_to_pbv (pbvsize s) 0) s))) (= s (int_to_pbv (pbvsize s) 0))))
(check-sat)
