(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= (int_to_pbv (pbvsize s) (pbvsize s)) (pbvurem (int_to_pbv (pbvsize s) 0) s)) (= s s)))
(check-sat)
