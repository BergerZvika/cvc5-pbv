(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr (int_to_pbv (pbvsize s) 1) (pbvshl (int_to_pbv (pbvsize s) 1) (pbvshl (int_to_pbv (pbvsize s) 1) s))) (pbvlshr (pbvmul s s) s)))
(check-sat)
