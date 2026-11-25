(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvlshr (pbvshl (int_to_pbv (pbvsize s) 0) s) (int_to_pbv (pbvsize s) 1))) (pbvmul s (pbvlshr (pbvshl s (int_to_pbv (pbvsize s) 1)) s))))
(check-sat)
