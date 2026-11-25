(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand (int_to_pbv (pbvsize s) 1) (pbvlshr (pbvmul s s) (int_to_pbv (pbvsize s) 1))) (int_to_pbv (pbvsize s) 1)))
(check-sat)
