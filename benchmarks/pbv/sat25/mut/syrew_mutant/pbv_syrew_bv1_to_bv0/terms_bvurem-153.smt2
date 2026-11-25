(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvshl (int_to_pbv (pbvsize s) 0) (pbvshl s s))) (pbvurem s (pbvshl s (pbvshl s s)))))
(check-sat)
