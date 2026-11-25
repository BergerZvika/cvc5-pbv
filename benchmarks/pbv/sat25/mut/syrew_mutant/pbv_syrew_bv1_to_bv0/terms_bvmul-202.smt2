(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr (int_to_pbv (pbvsize s) 0) (pbvshl (pbvnot s) (int_to_pbv (pbvsize s) 1))) (pbvand (int_to_pbv (pbvsize s) 1) (pbvlshr s (pbvmul s s)))))
(check-sat)
