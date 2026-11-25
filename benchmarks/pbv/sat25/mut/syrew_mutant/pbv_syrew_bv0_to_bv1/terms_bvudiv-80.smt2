(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr s (pbvudiv s (pbvand s (int_to_pbv (pbvsize s) 1)))) (int_to_pbv (pbvsize s) 1)))
(check-sat)
