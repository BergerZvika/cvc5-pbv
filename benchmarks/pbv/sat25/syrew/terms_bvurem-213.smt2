(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr s (pbvshl (int_to_pbv (pbvsize s) 1) (pbvurem (int_to_pbv (pbvsize s) 1) s))) (pbvlshr s (pbvshl (int_to_pbv (pbvsize s) 1) (int_to_pbv (pbvsize s) 1)))))
(check-sat)
