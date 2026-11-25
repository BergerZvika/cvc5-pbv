(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvudiv (int_to_pbv (pbvsize s) 0) (pbvudiv s s)) (int_to_pbv (pbvsize s) 0)))
(check-sat)
