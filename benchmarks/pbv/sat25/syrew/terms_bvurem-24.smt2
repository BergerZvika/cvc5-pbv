(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem (pbvnot (int_to_pbv (pbvsize s) 0)) s) (pbvurem (pbvnot s) s)))
(check-sat)
