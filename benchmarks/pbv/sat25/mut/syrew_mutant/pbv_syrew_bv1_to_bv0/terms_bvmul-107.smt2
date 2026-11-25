(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvshl (pbvand s (int_to_pbv (pbvsize s) 0)) (int_to_pbv (pbvsize s) 1))) (pbvmul s (pbvmul s (pbvshl s (int_to_pbv (pbvsize s) 1))))))
(check-sat)
