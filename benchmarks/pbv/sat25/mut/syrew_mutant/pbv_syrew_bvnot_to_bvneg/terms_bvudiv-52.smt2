(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr s (pbvneg (pbvudiv s s))) (int_to_pbv (pbvsize s) 0)))
(check-sat)
