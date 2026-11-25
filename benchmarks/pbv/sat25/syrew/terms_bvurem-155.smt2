(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvlshr (int_to_pbv (pbvsize s) 1) (pbvshl s s))) (pbvurem s (pbvshl s (pbvshl s s)))))
(check-sat)
