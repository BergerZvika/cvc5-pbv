(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvlshr (int_to_pbv (pbvsize s) 1) (pbvmul s s))) (= s (int_to_pbv (pbvsize s) 1))))
(check-sat)
