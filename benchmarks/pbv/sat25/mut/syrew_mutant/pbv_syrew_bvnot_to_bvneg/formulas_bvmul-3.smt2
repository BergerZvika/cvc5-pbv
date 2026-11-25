(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvneg (pbvmul s s))) (distinct s s)))
(check-sat)
