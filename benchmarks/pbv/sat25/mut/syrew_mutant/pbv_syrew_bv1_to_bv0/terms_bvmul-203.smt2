(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand (int_to_pbv (pbvsize s) 0) (pbvlshr (pbvmul s s) s)) (pbvlshr (pbvmul s s) s)))
(check-sat)
