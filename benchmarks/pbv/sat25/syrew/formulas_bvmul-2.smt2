(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvnot (pbvmul s s))) (= s s)))
(check-sat)
