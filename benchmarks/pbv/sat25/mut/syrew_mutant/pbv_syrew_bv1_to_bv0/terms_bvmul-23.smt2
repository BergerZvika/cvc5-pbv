(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvmul s (pbvmul s s))) (pbvand s (int_to_pbv (pbvsize s) 0))))
(check-sat)
