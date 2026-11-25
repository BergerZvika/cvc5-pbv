(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvudiv s (pbvlshr (int_to_pbv (pbvsize s) 1) s))) (= s (pbvneg (pbvudiv (int_to_pbv (pbvsize s) 0) s)))))
(check-sat)
