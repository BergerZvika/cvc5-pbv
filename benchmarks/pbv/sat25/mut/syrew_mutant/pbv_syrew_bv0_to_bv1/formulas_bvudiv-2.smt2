(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvudiv s s)) (= s (int_to_pbv (pbvsize s) 1))))
(check-sat)
