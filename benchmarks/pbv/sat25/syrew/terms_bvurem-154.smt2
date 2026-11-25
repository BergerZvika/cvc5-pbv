(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvlshr (int_to_pbv (pbvsize s) 1) (pbvshl s s))) (pbvurem s (pbvlshr s (pbvurem (int_to_pbv (pbvsize s) 1) s)))))
(check-sat)
