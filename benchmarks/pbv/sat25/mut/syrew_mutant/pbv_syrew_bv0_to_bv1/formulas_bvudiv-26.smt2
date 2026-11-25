(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult (int_to_pbv (pbvsize s) 1) (pbvudiv s s)) (= s (int_to_pbv (pbvsize s) 1))))
(check-sat)
