(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvudiv s (pbvshl s s))) (distinct s (pbvnot (int_to_pbv (pbvsize s) 1)))))
(check-sat)
