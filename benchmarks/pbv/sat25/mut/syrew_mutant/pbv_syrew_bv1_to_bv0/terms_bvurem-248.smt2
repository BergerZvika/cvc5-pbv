(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr s (pbvshl (pbvshl s s) s)) (pbvlshr s (pbvurem s (pbvurem (int_to_pbv (pbvsize s) 0) s)))))
(check-sat)
