(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvudiv s (pbvudiv (int_to_pbv (pbvsize s) 0) (pbvor s (int_to_pbv (pbvsize s) 1)))) (pbvnot (pbvudiv (int_to_pbv (pbvsize s) 0) (pbvand s (int_to_pbv (pbvsize s) 1))))))
(check-sat)
