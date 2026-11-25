(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvshl (int_to_pbv (pbvsize s) 1) (pbvudiv (int_to_pbv (pbvsize s) 0) s)) (pbvudiv (int_to_pbv (pbvsize s) 1) (pbvudiv s s))))
(check-sat)
