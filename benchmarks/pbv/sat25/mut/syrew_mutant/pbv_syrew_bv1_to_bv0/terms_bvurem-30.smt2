(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem (pbvlshr s (int_to_pbv (pbvsize s) 0)) s) (pbvlshr s (int_to_pbv (pbvsize s) 1))))
(check-sat)
