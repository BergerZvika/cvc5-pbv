(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvmul s s)) (pbvult (int_to_pbv (pbvsize s) 1) s)))
(check-sat)
