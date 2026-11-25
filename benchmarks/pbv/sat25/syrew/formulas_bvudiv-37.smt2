(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule (pbvudiv s s) (int_to_pbv (pbvsize s) 1)) (distinct s (int_to_pbv (pbvsize s) 0))))
(check-sat)
