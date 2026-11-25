(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvurem (int_to_pbv (pbvsize s) 1) s)) (distinct s (int_to_pbv (pbvsize s) 0))))
(check-sat)
