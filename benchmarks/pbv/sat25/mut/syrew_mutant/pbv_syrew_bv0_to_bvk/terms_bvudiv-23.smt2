(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvudiv (int_to_pbv (pbvsize s) 1) (pbvudiv (int_to_pbv (pbvsize s) (pbvsize s)) s)) (pbvnot (pbvudiv (int_to_pbv (pbvsize s) 0) s))))
(check-sat)
