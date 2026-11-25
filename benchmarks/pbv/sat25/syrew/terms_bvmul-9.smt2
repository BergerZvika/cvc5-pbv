(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvshl (pbvmul s s) s) (pbvmul s (pbvshl s s))))
(check-sat)
