(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvlshr (pbvshl s s) (int_to_pbv (pbvsize s) 1))) (pbvshl s (pbvand s (pbvneg (int_to_pbv (pbvsize s) 1))))))
(check-sat)
