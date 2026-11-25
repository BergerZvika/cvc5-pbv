(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvmul s (pbvlshr (int_to_pbv (pbvsize s) 1) s))) (distinct s s)))
(check-sat)
