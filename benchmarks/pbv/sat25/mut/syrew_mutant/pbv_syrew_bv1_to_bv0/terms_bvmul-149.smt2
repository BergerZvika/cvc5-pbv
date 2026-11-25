(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvlshr (pbvshl (int_to_pbv (pbvsize s) 0) (int_to_pbv (pbvsize s) 1)) s)) (pbvlshr s (pbvand s (pbvnot (int_to_pbv (pbvsize s) 1))))))
(check-sat)
