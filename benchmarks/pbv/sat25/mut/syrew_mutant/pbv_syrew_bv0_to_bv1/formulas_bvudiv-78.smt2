(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvshl s (pbvudiv s s))) (distinct s (int_to_pbv (pbvsize s) 1))))
(check-sat)
