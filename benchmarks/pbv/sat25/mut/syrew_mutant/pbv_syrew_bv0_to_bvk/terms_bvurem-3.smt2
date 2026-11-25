(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvurem s (int_to_pbv (pbvsize s) (pbvsize s)))) s))
(check-sat)
