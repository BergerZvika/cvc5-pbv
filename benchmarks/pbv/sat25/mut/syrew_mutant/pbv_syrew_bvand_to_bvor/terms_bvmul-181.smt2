(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvor (int_to_pbv (pbvsize s) 1) (pbvmul s (pbvmul s s))) (pbvand s (int_to_pbv (pbvsize s) 1))))
(check-sat)
