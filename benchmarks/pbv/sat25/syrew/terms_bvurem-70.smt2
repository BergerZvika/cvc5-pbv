(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvurem s (pbvurem (int_to_pbv (pbvsize s) 1) s))) (pbvurem s (pbvurem (int_to_pbv (pbvsize s) 1) s))))
(check-sat)
