(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult (pbvurem (int_to_pbv (pbvsize s) 0) s) s) (distinct s (int_to_pbv (pbvsize s) 0))))
(check-sat)
