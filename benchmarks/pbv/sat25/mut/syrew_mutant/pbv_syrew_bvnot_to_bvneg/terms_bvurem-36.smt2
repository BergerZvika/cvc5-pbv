(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvneg (pbvshl s s))) (pbvurem s (pbvnot (int_to_pbv (pbvsize s) 0)))))
(check-sat)
