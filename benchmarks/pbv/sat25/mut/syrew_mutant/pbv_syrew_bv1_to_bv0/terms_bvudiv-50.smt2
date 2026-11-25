(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvnot (pbvudiv s s))) (pbvand s (pbvnot (int_to_pbv (pbvsize s) 0)))))
(check-sat)
