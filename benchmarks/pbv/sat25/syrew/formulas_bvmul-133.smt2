(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvlshr (pbvmul s s) s)) (distinct s s)))
(check-sat)
