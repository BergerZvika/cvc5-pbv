(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvneg (pbvmul s s))) (= s s)))
(check-sat)
