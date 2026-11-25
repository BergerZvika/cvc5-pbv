(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem (pbvlshr (int_to_pbv (pbvsize s) 1) s) s) (pbvlshr (int_to_pbv (pbvsize s) 1) s)))
(check-sat)
