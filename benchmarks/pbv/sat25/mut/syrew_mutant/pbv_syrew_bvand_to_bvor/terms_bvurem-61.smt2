(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvurem s (pbvor s (int_to_pbv (pbvsize s) 1)))) (pbvlshr s (pbvurem s (pbvand s (int_to_pbv (pbvsize s) 1))))))
(check-sat)
