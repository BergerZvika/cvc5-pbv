(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvnot (pbvurem (int_to_pbv (pbvsize s) (pbvsize s)) s))) (= s (pbvnot (int_to_pbv (pbvsize s) 0)))))
(check-sat)
