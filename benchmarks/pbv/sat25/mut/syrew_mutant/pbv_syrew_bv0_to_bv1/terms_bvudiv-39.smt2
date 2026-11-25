(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvnot (pbvudiv s (pbvlshr s s))) (int_to_pbv (pbvsize s) 1)))
(check-sat)
