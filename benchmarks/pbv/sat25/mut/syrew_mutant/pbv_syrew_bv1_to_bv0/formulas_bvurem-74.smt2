(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvnot (pbvurem (int_to_pbv (pbvsize s) 0) s))) (distinct s (pbvnot (int_to_pbv (pbvsize s) 0)))))
(check-sat)
