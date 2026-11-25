(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvnot (pbvmul s s))) (distinct s s)))
(check-sat)
