(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvnot (pbvshl (pbvudiv (int_to_pbv (pbvsize s) 0) s) (int_to_pbv (pbvsize s) 1))) (pbvudiv (int_to_pbv (pbvsize s) 1) (pbvlshr (int_to_pbv (pbvsize s) 1) s))))
(check-sat)
