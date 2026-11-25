(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct (int_to_pbv (pbvsize s) 1) (pbvudiv (int_to_pbv (pbvsize s) 0) s)) (= s (int_to_pbv (pbvsize s) 0))))
(check-sat)
