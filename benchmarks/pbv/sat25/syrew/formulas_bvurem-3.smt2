(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvurem s (int_to_pbv (pbvsize s) 0))) (= s s)))
(check-sat)
