(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= (int_to_pbv (pbvsize s) 0) (pbvudiv s s)) (distinct s (int_to_pbv (pbvsize s) 0))))
(check-sat)
