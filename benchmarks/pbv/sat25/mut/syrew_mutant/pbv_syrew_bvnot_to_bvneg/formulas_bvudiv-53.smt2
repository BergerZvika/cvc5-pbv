(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvneg (pbvudiv (int_to_pbv (pbvsize s) 1) s))) (distinct s (pbvnot (pbvudiv (int_to_pbv (pbvsize s) 0) s)))))
(check-sat)
