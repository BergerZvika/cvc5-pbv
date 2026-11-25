(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvlshr (pbvmul s s) (int_to_pbv (pbvsize s) 1))) (distinct s (pbvand s (pbvshl (int_to_pbv (pbvsize s) 1) (int_to_pbv (pbvsize s) 1))))))
(check-sat)
