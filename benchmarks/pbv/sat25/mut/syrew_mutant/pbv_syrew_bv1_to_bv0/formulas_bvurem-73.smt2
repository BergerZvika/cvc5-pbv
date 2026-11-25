(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvnot (pbvurem (int_to_pbv (pbvsize s) 0) s))) (pbvult s (pbvnot (int_to_pbv (pbvsize s) 1)))))
(check-sat)
