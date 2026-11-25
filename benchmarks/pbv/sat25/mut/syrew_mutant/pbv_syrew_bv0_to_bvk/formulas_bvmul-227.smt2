(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= (int_to_pbv (pbvsize s) (pbvsize s)) (pbvmul s (pbvlshr s (int_to_pbv (pbvsize s) 1)))) (pbvule s (pbvshl s (pbvshl s (int_to_pbv (pbvsize s) 1))))))
(check-sat)
