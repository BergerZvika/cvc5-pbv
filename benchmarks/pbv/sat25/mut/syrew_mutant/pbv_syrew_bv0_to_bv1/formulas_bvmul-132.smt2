(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvlshr (pbvmul s s) s)) (= s (int_to_pbv (pbvsize s) 1))))
(check-sat)
