(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvmul s (pbvlshr s s))) (= s (int_to_pbv (pbvsize s) 1))))
(check-sat)
