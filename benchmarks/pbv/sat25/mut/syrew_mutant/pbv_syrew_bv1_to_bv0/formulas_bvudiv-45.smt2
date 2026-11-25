(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult (pbvudiv (int_to_pbv (pbvsize s) 0) s) s) (pbvult (int_to_pbv (pbvsize s) 1) s)))
(check-sat)
