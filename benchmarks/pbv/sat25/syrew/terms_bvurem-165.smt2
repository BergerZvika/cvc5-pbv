(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr s (pbvurem (int_to_pbv (pbvsize s) 1) (pbvlshr s (int_to_pbv (pbvsize s) 1)))) (pbvlshr s (pbvshl (int_to_pbv (pbvsize s) 1) (pbvshl s s)))))
(check-sat)
