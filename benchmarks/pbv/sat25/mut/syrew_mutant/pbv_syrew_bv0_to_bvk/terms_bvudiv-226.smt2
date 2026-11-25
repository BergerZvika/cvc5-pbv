(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvudiv (int_to_pbv (pbvsize s) 1) (pbvnot s))) (pbvudiv (int_to_pbv (pbvsize s) (pbvsize s)) (pbvnot s))))
(check-sat)
