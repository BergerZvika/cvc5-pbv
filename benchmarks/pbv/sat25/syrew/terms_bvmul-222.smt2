(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand (pbvlshr s s) (pbvmul s s)) (int_to_pbv (pbvsize s) 0)))
(check-sat)
