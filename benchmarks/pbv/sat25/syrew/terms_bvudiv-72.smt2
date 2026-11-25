(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr s (pbvand s (pbvnot (int_to_pbv (pbvsize s) 1)))) (pbvand s (pbvudiv (int_to_pbv (pbvsize s) 1) s))))
(check-sat)
