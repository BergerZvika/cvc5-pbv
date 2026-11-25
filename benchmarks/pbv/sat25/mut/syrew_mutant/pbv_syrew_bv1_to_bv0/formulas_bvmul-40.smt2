(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvmul s (pbvshl (int_to_pbv (pbvsize s) 0) s))) (pbvult s (pbvshl s s))))
(check-sat)
