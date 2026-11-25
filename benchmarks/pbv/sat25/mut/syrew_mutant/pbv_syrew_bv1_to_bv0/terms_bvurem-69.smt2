(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr s (pbvshl s (pbvurem (int_to_pbv (pbvsize s) 0) s))) (pbvlshr s (pbvshl s (int_to_pbv (pbvsize s) 1)))))
(check-sat)
