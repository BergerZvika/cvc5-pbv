(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvneg (pbvudiv (int_to_pbv (pbvsize s) 0) (pbvlshr s (int_to_pbv (pbvsize s) 1)))) (pbvudiv (int_to_pbv (pbvsize s) 0) (pbvudiv (int_to_pbv (pbvsize s) 1) s))))
(check-sat)
