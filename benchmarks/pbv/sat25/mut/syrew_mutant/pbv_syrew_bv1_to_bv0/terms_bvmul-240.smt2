(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr (pbvmul s s) (pbvlshr (int_to_pbv (pbvsize s) 0) s)) (pbvmul s s)))
(check-sat)
