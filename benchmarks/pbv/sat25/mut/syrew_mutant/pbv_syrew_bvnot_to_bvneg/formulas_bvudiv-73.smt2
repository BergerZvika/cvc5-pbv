(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvudiv s (pbvlshr s s))) (= s (pbvneg (int_to_pbv (pbvsize s) 0)))))
(check-sat)
