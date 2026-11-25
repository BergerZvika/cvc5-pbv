(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= (int_to_pbv (pbvsize s) (pbvsize s)) (pbvurem (int_to_pbv (pbvsize s) 1) s)) (= s (int_to_pbv (pbvsize s) 1))))
(check-sat)
