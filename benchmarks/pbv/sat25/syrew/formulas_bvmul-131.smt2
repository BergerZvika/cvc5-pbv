(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvlshr (pbvmul s s) s)) (distinct s (int_to_pbv (pbvsize s) 0))))
(check-sat)
