(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvshl s (pbvmul s s))) (distinct (int_to_pbv (pbvsize s) (pbvsize s)) (pbvmul s s))))
(check-sat)
