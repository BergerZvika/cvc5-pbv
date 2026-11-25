(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvnot (pbvshl (int_to_pbv (pbvsize s) 1) s))) (pbvurem s (pbvnot (int_to_pbv (pbvsize s) (pbvsize s))))))
(check-sat)
