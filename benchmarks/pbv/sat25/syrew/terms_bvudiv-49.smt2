(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvudiv s (pbvnot (pbvshl s s))) (pbvudiv s (pbvnot (int_to_pbv (pbvsize s) 0)))))
(check-sat)
