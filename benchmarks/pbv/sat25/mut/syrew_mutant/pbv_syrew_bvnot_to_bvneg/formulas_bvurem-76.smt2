(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvurem s (pbvneg (int_to_pbv (pbvsize s) 0)))) (distinct s (pbvnot (int_to_pbv (pbvsize s) 0)))))
(check-sat)
