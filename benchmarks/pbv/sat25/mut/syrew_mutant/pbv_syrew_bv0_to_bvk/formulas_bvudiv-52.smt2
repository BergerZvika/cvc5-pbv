(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvnot (pbvudiv (int_to_pbv (pbvsize s) 1) s))) (= s (pbvnot (pbvudiv (int_to_pbv (pbvsize s) (pbvsize s)) s)))))
(check-sat)
