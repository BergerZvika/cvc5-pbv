(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvlshr (int_to_pbv (pbvsize s) 0) (pbvlshr s (int_to_pbv (pbvsize s) 1)))) (pbvlshr s (pbvurem s (pbvurem (int_to_pbv (pbvsize s) 1) s)))))
(check-sat)
