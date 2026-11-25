(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr (pbvudiv s s) s) (pbvudiv (int_to_pbv (pbvsize s) 1) s)))
(check-sat)
