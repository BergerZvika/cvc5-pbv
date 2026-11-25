(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvudiv (int_to_pbv (pbvsize s) (pbvsize s)) (pbvlshr s (int_to_pbv (pbvsize s) 1)))) (pbvand s (pbvudiv (int_to_pbv (pbvsize s) 1) s))))
(check-sat)
