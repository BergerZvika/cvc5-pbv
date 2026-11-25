(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvurem s (int_to_pbv (pbvsize s) (pbvsize s)))) (= s s)))
(check-sat)
