(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvudiv s (pbvshl (int_to_pbv (pbvsize s) 0) (pbvand s (int_to_pbv (pbvsize s) 1)))) (pbvlshr s (pbvand s (int_to_pbv (pbvsize s) 1)))))
(check-sat)
