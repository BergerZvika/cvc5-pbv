(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvlshr (pbvshl s s) (int_to_pbv (pbvsize s) 0))) (pbvshl s (pbvand s (pbvnot (int_to_pbv (pbvsize s) 1))))))
(check-sat)
