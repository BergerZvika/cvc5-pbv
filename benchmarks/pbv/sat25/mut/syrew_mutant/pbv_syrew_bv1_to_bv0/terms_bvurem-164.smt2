(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvurem (int_to_pbv (pbvsize s) 0) (pbvlshr s (int_to_pbv (pbvsize s) 1)))) (pbvurem s (pbvlshr s (int_to_pbv (pbvsize s) 1)))))
(check-sat)
