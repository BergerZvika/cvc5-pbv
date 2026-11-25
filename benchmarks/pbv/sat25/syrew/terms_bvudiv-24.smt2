(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr (int_to_pbv (pbvsize s) 1) (pbvlshr (int_to_pbv (pbvsize s) 1) s)) (pbvudiv (int_to_pbv (pbvsize s) 1) (pbvudiv s s))))
(check-sat)
