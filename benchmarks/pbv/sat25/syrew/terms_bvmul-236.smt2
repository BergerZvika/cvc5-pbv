(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr (pbvmul s s) (pbvshl s (int_to_pbv (pbvsize s) 1))) (int_to_pbv (pbvsize s) 0)))
(check-sat)
