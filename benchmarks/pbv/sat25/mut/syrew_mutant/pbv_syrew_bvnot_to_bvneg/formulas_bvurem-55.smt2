(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvneg (pbvurem s (int_to_pbv (pbvsize s) 0)))) (= s s)))
(check-sat)
