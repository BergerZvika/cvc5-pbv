(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvurem s (pbvnot (int_to_pbv (pbvsize s) 0)))) (pbvult s (pbvnot (int_to_pbv (pbvsize s) 1)))))
(check-sat)
