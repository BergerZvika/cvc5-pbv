(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvudiv (int_to_pbv (pbvsize s) 0) (pbvudiv (int_to_pbv (pbvsize s) 1) s)) (pbvudiv s (pbvudiv (int_to_pbv (pbvsize s) 1) s))))
(check-sat)
