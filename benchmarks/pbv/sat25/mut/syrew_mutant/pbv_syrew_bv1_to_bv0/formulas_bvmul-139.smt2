(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvshl (pbvmul s s) (int_to_pbv (pbvsize s) 0))) (= s (int_to_pbv (pbvsize s) 0))))
(check-sat)
