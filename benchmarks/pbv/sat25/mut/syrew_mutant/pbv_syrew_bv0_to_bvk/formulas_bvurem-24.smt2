(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct (int_to_pbv (pbvsize s) (pbvsize s)) (pbvurem (int_to_pbv (pbvsize s) 0) s)) (distinct s s)))
(check-sat)
