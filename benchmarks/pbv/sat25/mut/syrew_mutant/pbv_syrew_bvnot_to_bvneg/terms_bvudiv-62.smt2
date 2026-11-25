(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvudiv s (pbvneg (pbvshl (int_to_pbv (pbvsize s) 1) s))) (pbvudiv s (pbvnot (int_to_pbv (pbvsize s) 0)))))
(check-sat)
