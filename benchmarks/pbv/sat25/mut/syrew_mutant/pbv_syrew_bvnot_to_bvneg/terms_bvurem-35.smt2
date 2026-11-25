(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvneg (pbvurem (pbvnot s) (int_to_pbv (pbvsize s) 0))) s))
(check-sat)
