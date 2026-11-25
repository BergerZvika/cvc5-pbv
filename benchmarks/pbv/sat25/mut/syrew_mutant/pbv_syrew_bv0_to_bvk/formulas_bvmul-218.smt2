(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct (int_to_pbv (pbvsize s) (pbvsize s)) (pbvmul s (pbvlshr s s))) (distinct s s)))
(check-sat)
