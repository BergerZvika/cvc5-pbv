(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvlshr (int_to_pbv (pbvsize s) 1) s)) (int_to_pbv (pbvsize s) 0)))
(check-sat)
