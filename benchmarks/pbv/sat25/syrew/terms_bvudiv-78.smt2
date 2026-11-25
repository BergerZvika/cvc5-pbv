(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvudiv s (pbvand s (int_to_pbv (pbvsize s) 1)))) s))
(check-sat)
