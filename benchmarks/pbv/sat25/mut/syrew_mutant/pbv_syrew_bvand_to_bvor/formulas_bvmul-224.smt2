(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= (int_to_pbv (pbvsize s) 0) (pbvmul s (pbvor s (int_to_pbv (pbvsize s) 1)))) (= (int_to_pbv (pbvsize s) 0) (pbvand s (int_to_pbv (pbvsize s) 1)))))
(check-sat)
