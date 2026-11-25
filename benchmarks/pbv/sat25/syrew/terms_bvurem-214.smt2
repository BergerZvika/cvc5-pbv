(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvshl (int_to_pbv (pbvsize s) 1) (pbvurem (int_to_pbv (pbvsize s) 1) s))) (pbvand s (pbvurem (int_to_pbv (pbvsize s) 1) s))))
(check-sat)
