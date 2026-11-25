(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvurem s (pbvnot (int_to_pbv (pbvsize s) 1)))) (pbvurem s (pbvnot (int_to_pbv (pbvsize s) 1)))))
(check-sat)
