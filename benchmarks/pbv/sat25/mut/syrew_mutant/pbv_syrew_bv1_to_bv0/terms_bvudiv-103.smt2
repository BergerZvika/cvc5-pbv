(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvudiv s (pbvlshr s (pbvudiv (int_to_pbv (pbvsize s) 0) s))) (pbvudiv s (pbvand s (pbvnot (int_to_pbv (pbvsize s) 1))))))
(check-sat)
