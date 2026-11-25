(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult (pbvudiv (int_to_pbv (pbvsize s) 1) s) s) (pbvult (int_to_pbv (pbvsize s) 1) s)))
(check-sat)
