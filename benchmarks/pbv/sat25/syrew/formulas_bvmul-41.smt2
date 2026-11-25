(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvmul s (pbvshl (int_to_pbv (pbvsize s) 1) s))) (pbvule s (pbvshl s s))))
(check-sat)
