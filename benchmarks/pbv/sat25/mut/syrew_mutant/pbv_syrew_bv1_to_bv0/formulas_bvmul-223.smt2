(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct (int_to_pbv (pbvsize s) 0) (pbvmul s (pbvand s (int_to_pbv (pbvsize s) 0)))) (distinct (int_to_pbv (pbvsize s) 0) (pbvand s (int_to_pbv (pbvsize s) 1)))))
(check-sat)
