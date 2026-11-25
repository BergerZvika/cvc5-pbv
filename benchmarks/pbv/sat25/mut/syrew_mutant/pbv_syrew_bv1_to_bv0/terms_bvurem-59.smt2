(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvlshr s (pbvand s (int_to_pbv (pbvsize s) 0)))) (pbvurem s (pbvlshr s (int_to_pbv (pbvsize s) 1)))))
(check-sat)
