(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvudiv s (pbvand s (int_to_pbv (pbvsize s) 1)))) (distinct (int_to_pbv (pbvsize s) (pbvsize s)) (pbvand s (int_to_pbv (pbvsize s) 1)))))
(check-sat)
