(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvmul s (pbvshl s s))) (pbvmul s (pbvshl s s))))
(check-sat)
