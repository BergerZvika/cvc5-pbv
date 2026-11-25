(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvudiv s (pbvneg (pbvand s (int_to_pbv (pbvsize s) 1)))) (pbvudiv s (pbvnot (int_to_pbv (pbvsize s) 0)))))
(check-sat)
