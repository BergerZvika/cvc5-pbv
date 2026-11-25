(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvudiv (pbvand s (int_to_pbv (pbvsize s) 1)) s) (pbvudiv (int_to_pbv (pbvsize s) 1) s)))
(check-sat)
