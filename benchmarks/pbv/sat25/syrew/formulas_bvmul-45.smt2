(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvmul s (pbvlshr (int_to_pbv (pbvsize s) 1) s))) (= s (int_to_pbv (pbvsize s) 0))))
(check-sat)
