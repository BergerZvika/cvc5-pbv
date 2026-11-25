(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvand s (pbvudiv (int_to_pbv (pbvsize s) 0) s))) (pbvult (int_to_pbv (pbvsize s) 1) s)))
(check-sat)
