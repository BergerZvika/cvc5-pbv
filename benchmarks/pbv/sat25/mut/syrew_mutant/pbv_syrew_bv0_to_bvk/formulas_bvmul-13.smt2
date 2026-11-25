(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvmul s (pbvlshr s s))) (= s (int_to_pbv (pbvsize s) (pbvsize s)))))
(check-sat)
