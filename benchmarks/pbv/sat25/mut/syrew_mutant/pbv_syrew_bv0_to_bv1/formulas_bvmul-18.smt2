(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvshl s (pbvmul s s))) (distinct (int_to_pbv (pbvsize s) 1) (pbvmul s s))))
(check-sat)
