(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvlshr (int_to_pbv (pbvsize s) 0) (pbvlshr s (int_to_pbv (pbvsize s) 1)))) (pbvlshr s (pbvand s (pbvnot (int_to_pbv (pbvsize s) 1))))))
(check-sat)
