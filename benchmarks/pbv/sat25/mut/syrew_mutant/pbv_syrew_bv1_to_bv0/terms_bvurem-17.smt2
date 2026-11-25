(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem (int_to_pbv (pbvsize s) 0) (pbvshl s s)) (int_to_pbv (pbvsize s) 1)))
(check-sat)
