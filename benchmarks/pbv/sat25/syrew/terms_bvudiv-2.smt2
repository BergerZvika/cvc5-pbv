(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvshl s (pbvudiv s s)) (pbvshl s (int_to_pbv (pbvsize s) 1))))
(check-sat)
