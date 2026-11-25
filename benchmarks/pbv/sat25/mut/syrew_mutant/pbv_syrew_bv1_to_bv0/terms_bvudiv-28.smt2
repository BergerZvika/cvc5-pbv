(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvudiv (pbvudiv s s) s) (pbvudiv (int_to_pbv (pbvsize s) 0) s)))
(check-sat)
