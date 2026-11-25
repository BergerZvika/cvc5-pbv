(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvshl (int_to_pbv (pbvsize s) 0) (pbvand s (int_to_pbv (pbvsize s) 1)))) (pbvand s (int_to_pbv (pbvsize s) 1))))
(check-sat)
