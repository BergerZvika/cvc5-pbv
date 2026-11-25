(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvor s (pbvurem (int_to_pbv (pbvsize s) 1) (pbvnot s))) (pbvand s (int_to_pbv (pbvsize s) 1))))
(check-sat)
