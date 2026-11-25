(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= (int_to_pbv (pbvsize s) 1) (pbvurem (int_to_pbv (pbvsize s) (pbvsize s)) s)) (distinct s s)))
(check-sat)
