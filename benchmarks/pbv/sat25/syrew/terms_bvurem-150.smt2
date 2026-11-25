(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvurem (int_to_pbv (pbvsize s) 1) (pbvnot s))) (pbvurem s (pbvurem s (pbvnot (int_to_pbv (pbvsize s) 1))))))
(check-sat)
