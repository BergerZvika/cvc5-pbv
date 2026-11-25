(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvnot (pbvmul s s))) (pbvult s (pbvnot (pbvmul s s)))))
(check-sat)
