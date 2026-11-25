(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvneg (pbvurem (int_to_pbv (pbvsize s) 1) s))) (distinct s (pbvnot (int_to_pbv (pbvsize s) 1)))))
(check-sat)
