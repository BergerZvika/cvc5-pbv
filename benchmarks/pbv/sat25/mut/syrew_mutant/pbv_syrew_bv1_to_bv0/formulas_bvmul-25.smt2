(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvmul s (pbvand s (int_to_pbv (pbvsize s) 0)))) (= s (pbvmul s (pbvand s (int_to_pbv (pbvsize s) 1))))))
(check-sat)
