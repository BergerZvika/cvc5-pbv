(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct (int_to_pbv (pbvsize s) 1) (pbvurem (int_to_pbv (pbvsize s) 1) s)) (distinct s (int_to_pbv (pbvsize s) 1))))
(check-sat)
