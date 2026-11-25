(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvand (int_to_pbv (pbvsize s) 0) (pbvnot s))) (pbvlshr s (pbvurem s (pbvand s (int_to_pbv (pbvsize s) 1))))))
(check-sat)
