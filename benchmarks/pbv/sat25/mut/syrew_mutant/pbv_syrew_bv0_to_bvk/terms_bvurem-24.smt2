(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem (pbvnot (int_to_pbv (pbvsize s) (pbvsize s))) s) (pbvurem (pbvnot s) s)))
(check-sat)
