(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr s (pbvneg (pbvurem (int_to_pbv (pbvsize s) 1) s))) (int_to_pbv (pbvsize s) 0)))
(check-sat)
