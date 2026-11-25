(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= (int_to_pbv (pbvsize s) (pbvsize s)) (pbvshl s (pbvshl s s))) (= s (pbvmul s (pbvlshr s (int_to_pbv (pbvsize s) 1))))))
(check-sat)
