(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvshl s (pbvudiv (int_to_pbv (pbvsize s) 0) s))) (pbvlshr s (pbvudiv (int_to_pbv (pbvsize s) 1) s))))
(check-sat)
