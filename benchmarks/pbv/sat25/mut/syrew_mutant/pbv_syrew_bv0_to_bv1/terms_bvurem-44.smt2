(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvshl s (pbvnot (pbvurem (int_to_pbv (pbvsize s) 1) s))) (int_to_pbv (pbvsize s) 1)))
(check-sat)
