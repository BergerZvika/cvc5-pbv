(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvmul s (pbvlshr s s))) (distinct s s)))
(check-sat)
