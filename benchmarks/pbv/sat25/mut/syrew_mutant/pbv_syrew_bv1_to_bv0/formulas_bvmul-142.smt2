(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvlshr (pbvmul s s) (int_to_pbv (pbvsize s) 0))) (= s (pbvmul s (pbvlshr s (int_to_pbv (pbvsize s) 1))))))
(check-sat)
