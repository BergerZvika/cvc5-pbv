(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvudiv s (pbvlshr s s)) (pbvnot (int_to_pbv (pbvsize s) (pbvsize s)))))
(check-sat)
