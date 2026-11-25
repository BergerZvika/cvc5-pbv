(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvudiv s (pbvshl (int_to_pbv (pbvsize s) 0) (pbvlshr s s))) s))
(check-sat)
