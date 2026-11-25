(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvudiv (int_to_pbv (pbvsize s) 0) s)) (pbvule s (int_to_pbv (pbvsize s) 1))))
(check-sat)
