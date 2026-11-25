(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvudiv s (pbvudiv (int_to_pbv (pbvsize s) 1) s))) (distinct s (pbvudiv s (pbvudiv (int_to_pbv (pbvsize s) 1) s)))))
(check-sat)
