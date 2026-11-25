(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvlshr (int_to_pbv (pbvsize s) 0) (pbvmul s s))) (= s s)))
(check-sat)
