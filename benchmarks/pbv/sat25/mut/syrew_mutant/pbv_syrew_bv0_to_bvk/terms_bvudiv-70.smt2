(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvudiv s (pbvnot (int_to_pbv (pbvsize s) (pbvsize s))))) (pbvudiv s (pbvnot (int_to_pbv (pbvsize s) 0)))))
(check-sat)
