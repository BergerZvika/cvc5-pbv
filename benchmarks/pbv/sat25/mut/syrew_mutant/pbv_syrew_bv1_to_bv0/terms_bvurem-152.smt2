(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvshl (int_to_pbv (pbvsize s) 0) (pbvshl s s))) (pbvurem s (pbvlshr s (pbvurem (int_to_pbv (pbvsize s) 1) s)))))
(check-sat)
