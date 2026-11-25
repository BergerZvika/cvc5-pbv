(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvnot (pbvurem (int_to_pbv (pbvsize s) (pbvsize s)) s))) (= s s)))
(check-sat)
