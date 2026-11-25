(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvurem s (int_to_pbv (pbvsize s) (pbvsize s)))) (distinct s s)))
(check-sat)
