(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvudiv s (pbvlshr s (int_to_pbv (pbvsize s) 1)))) (= (int_to_pbv (pbvsize s) 1) (pbvlshr s (int_to_pbv (pbvsize s) 1)))))
(check-sat)
