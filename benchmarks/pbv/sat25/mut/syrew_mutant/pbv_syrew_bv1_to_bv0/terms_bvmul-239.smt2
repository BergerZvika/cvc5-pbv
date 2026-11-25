(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand (pbvmul s s) (pbvshl (int_to_pbv (pbvsize s) 0) s)) (pbvshl (pbvlshr s (int_to_pbv (pbvsize s) 1)) s)))
(check-sat)
