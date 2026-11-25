(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvurem (int_to_pbv (pbvsize s) 0) (pbvshl s s))) (int_to_pbv (pbvsize s) 0)))
(check-sat)
