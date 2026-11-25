(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvudiv s (pbvnot (pbvand s (int_to_pbv (pbvsize s) 1)))) (pbvudiv s (pbvnot (int_to_pbv (pbvsize s) (pbvsize s))))))
(check-sat)
