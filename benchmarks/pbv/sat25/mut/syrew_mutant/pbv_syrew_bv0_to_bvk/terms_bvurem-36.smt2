(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvnot (pbvshl s s))) (pbvurem s (pbvnot (int_to_pbv (pbvsize s) (pbvsize s))))))
(check-sat)
