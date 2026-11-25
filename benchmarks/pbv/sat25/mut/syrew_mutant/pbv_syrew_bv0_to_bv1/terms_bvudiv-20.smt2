(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr (int_to_pbv (pbvsize s) 1) (pbvudiv s s)) (int_to_pbv (pbvsize s) 1)))
(check-sat)
