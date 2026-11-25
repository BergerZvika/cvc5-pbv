(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvneg (pbvurem (int_to_pbv (pbvsize s) 1) s))) (= s (pbvnot (int_to_pbv (pbvsize s) 1)))))
(check-sat)
