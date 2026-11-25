(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvurem s (int_to_pbv (pbvsize s) (pbvsize s)))) (int_to_pbv (pbvsize s) 0)))
(check-sat)
