(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvlshr (int_to_pbv (pbvsize s) 0) s)) s))
(check-sat)
