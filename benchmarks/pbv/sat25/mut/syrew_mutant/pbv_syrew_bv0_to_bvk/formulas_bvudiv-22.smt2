(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct (int_to_pbv (pbvsize s) (pbvsize s)) (pbvudiv (int_to_pbv (pbvsize s) 0) s)) (= s (int_to_pbv (pbvsize s) 0))))
(check-sat)
