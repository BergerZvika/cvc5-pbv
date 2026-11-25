(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvor s (pbvudiv (int_to_pbv (pbvsize s) 0) (pbvnot s))) (pbvudiv (int_to_pbv (pbvsize s) 0) (pbvnot s))))
(check-sat)
