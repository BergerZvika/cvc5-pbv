(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvneg (pbvudiv s (pbvudiv (int_to_pbv (pbvsize s) 0) s))) (pbvudiv (int_to_pbv (pbvsize s) 0) s)))
(check-sat)
