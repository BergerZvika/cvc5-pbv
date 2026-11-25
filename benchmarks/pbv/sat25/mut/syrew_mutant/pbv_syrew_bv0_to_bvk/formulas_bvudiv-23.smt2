(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= (int_to_pbv (pbvsize s) (pbvsize s)) (pbvudiv (int_to_pbv (pbvsize s) 0) s)) (distinct s (int_to_pbv (pbvsize s) 0))))
(check-sat)
