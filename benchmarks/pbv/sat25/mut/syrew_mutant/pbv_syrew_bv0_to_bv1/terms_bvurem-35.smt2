(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvnot (pbvurem (pbvnot s) (int_to_pbv (pbvsize s) 1))) s))
(check-sat)
