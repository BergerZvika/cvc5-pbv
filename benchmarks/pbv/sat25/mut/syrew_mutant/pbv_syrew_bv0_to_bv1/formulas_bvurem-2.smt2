(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvurem s (int_to_pbv (pbvsize s) 1))) (distinct s s)))
(check-sat)
