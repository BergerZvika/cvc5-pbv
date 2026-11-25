(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvudiv (int_to_pbv (pbvsize s) 1) (pbvneg s))) (pbvudiv (int_to_pbv (pbvsize s) 0) (pbvnot s))))
(check-sat)
