(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvmul s (pbvlshr (int_to_pbv (pbvsize s) 0) s))) (distinct s (int_to_pbv (pbvsize s) 0))))
(check-sat)
