(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult (int_to_pbv (pbvsize s) 1) (pbvurem (int_to_pbv (pbvsize s) 1) s)) (distinct s s)))
(check-sat)
