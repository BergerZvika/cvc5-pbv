(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvudiv s (pbvudiv (int_to_pbv (pbvsize s) 1) s)) (pbvnot (pbvudiv (int_to_pbv (pbvsize s) 0) s))))
(check-sat)
