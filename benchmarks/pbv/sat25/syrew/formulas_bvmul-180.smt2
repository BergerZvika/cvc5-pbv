(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvlshr (pbvshl (int_to_pbv (pbvsize s) 1) s) (int_to_pbv (pbvsize s) 1))) (pbvult s (pbvlshr (pbvmul s s) (int_to_pbv (pbvsize s) 1)))))
(check-sat)
