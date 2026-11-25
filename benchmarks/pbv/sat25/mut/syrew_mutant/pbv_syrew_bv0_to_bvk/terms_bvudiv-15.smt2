(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvudiv (int_to_pbv (pbvsize s) (pbvsize s)) (pbvudiv (int_to_pbv (pbvsize s) 0) s)) (pbvnot (pbvudiv (int_to_pbv (pbvsize s) 0) s))))
(check-sat)
