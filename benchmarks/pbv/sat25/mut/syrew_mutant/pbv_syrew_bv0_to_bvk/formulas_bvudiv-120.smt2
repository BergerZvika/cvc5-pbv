(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvand s (pbvudiv (int_to_pbv (pbvsize s) (pbvsize s)) s))) (= s (int_to_pbv (pbvsize s) 0))))
(check-sat)
