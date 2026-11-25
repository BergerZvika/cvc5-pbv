(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand (int_to_pbv (pbvsize s) 0) (pbvudiv (int_to_pbv (pbvsize s) 1) s)) (pbvlshr (int_to_pbv (pbvsize s) 1) (pbvlshr s (int_to_pbv (pbvsize s) 1)))))
(check-sat)
