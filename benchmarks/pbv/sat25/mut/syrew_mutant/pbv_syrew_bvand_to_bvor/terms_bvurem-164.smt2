(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvor s (pbvurem (int_to_pbv (pbvsize s) 1) (pbvlshr s (int_to_pbv (pbvsize s) 1)))) (pbvurem s (pbvlshr s (int_to_pbv (pbvsize s) 1)))))
(check-sat)
