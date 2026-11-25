(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvudiv (pbvlshr (int_to_pbv (pbvsize s) 1) s) s) (pbvudiv (int_to_pbv (pbvsize s) 0) s)))
(check-sat)
