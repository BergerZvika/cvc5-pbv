(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvurem s (pbvand s (int_to_pbv (pbvsize s) 0)))) (pbvurem s (pbvand s (int_to_pbv (pbvsize s) 1)))))
(check-sat)
