(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvurem (int_to_pbv (pbvsize s) 0) s)) (= s (int_to_pbv (pbvsize s) 0))))
(check-sat)
