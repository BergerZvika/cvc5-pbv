(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvshl s (pbvudiv s s))) (pbvult s (pbvshl s (int_to_pbv (pbvsize s) 1)))))
(check-sat)
