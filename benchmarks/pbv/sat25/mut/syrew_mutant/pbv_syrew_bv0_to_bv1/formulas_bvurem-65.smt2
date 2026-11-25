(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvnot (pbvurem (int_to_pbv (pbvsize s) 1) s))) (distinct s (pbvnot (int_to_pbv (pbvsize s) 0)))))
(check-sat)
