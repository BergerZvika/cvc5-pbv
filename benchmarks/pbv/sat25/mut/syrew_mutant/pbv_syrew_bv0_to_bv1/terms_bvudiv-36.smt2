(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr (pbvudiv (int_to_pbv (pbvsize s) 1) s) (int_to_pbv (pbvsize s) 1)) (pbvlshr (pbvudiv s s) (int_to_pbv (pbvsize s) 1))))
(check-sat)
