(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvand s (pbvudiv s s))) (pbvule s (int_to_pbv (pbvsize s) 0))))
(check-sat)
