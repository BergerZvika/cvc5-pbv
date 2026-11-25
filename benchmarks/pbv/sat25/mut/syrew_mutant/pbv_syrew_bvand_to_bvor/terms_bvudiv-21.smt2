(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvor (int_to_pbv (pbvsize s) 1) (pbvudiv (int_to_pbv (pbvsize s) 0) s)) (pbvlshr (int_to_pbv (pbvsize s) 1) s)))
(check-sat)
