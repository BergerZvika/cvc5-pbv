(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvlshr (pbvmul s s) (int_to_pbv (pbvsize s) 1))) (= s (pbvor s (pbvshl (int_to_pbv (pbvsize s) 1) (int_to_pbv (pbvsize s) 1))))))
(check-sat)
