(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvudiv s (pbvudiv s (pbvneg (int_to_pbv (pbvsize s) 0)))) (pbvnot (int_to_pbv (pbvsize s) 0))))
(check-sat)
