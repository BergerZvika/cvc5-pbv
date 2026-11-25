(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvudiv (int_to_pbv (pbvsize s) (pbvsize s)) (pbvnot s))) (pbvudiv (int_to_pbv (pbvsize s) 0) (pbvnot s))))
(check-sat)
