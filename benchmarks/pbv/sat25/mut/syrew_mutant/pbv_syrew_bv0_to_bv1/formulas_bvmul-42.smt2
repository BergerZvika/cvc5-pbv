(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvmul s (pbvlshr (int_to_pbv (pbvsize s) 1) s))) (distinct s (int_to_pbv (pbvsize s) 1))))
(check-sat)
