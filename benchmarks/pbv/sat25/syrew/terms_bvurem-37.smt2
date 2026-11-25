(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvnot (pbvurem s (int_to_pbv (pbvsize s) 0)))) (int_to_pbv (pbvsize s) 0)))
(check-sat)
