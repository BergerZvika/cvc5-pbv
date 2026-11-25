(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr (int_to_pbv (pbvsize s) 1) (pbvneg s)) (pbvudiv s (pbvnot (int_to_pbv (pbvsize s) 0)))))
(check-sat)
