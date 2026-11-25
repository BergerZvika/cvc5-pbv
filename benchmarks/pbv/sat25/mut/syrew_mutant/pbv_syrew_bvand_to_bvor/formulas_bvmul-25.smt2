(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvmul s (pbvor s (int_to_pbv (pbvsize s) 1)))) (= s (pbvmul s (pbvand s (int_to_pbv (pbvsize s) 1))))))
(check-sat)
