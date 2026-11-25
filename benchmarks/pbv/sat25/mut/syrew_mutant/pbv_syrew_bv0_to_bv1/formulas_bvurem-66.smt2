(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvnot (pbvurem (int_to_pbv (pbvsize s) 1) s))) (= s s)))
(check-sat)
