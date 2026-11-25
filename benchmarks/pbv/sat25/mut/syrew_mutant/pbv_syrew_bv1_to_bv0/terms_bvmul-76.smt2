(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvand (int_to_pbv (pbvsize s) 0) (pbvmul s s))) (pbvand s (int_to_pbv (pbvsize s) 1))))
(check-sat)
