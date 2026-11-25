(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvudiv s (pbvudiv (int_to_pbv (pbvsize s) 0) s))) (distinct s (pbvnot (pbvudiv (int_to_pbv (pbvsize s) 0) s)))))
(check-sat)
