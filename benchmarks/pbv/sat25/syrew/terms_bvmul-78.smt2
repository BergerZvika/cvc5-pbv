(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvlshr (int_to_pbv (pbvsize s) 1) (pbvmul s s))) (pbvshl s (pbvshl s (pbvshl (int_to_pbv (pbvsize s) 1) (int_to_pbv (pbvsize s) 1))))))
(check-sat)
