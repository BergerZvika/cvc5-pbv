(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult (pbvudiv s s) s) (pbvult (int_to_pbv (pbvsize s) 0) s)))
(check-sat)
