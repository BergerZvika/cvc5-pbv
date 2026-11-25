(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvor (int_to_pbv (pbvsize s) 1) (pbvnot s))) (pbvlshr s (pbvmul s (pbvand s (int_to_pbv (pbvsize s) 1))))))
(check-sat)
