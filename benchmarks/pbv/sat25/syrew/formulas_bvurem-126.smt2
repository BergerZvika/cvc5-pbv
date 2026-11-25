(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvurem s (pbvlshr (int_to_pbv (pbvsize s) 1) s))) (= s s)))
(check-sat)
