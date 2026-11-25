(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvnot (pbvudiv (int_to_pbv (pbvsize s) 0) (pbvudiv (int_to_pbv (pbvsize s) 0) s))) (pbvudiv (int_to_pbv (pbvsize s) 0) (pbvlshr s (int_to_pbv (pbvsize s) 1)))))
(check-sat)
