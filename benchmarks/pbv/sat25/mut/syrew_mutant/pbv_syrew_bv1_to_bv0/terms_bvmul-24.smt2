(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvmul s (pbvand s (int_to_pbv (pbvsize s) 0)))) (pbvmul s (pbvand s (int_to_pbv (pbvsize s) 1)))))
(check-sat)
