(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct (int_to_pbv (pbvsize s) (pbvsize s)) (pbvmul s (pbvshl s (int_to_pbv (pbvsize s) 1)))) (distinct (int_to_pbv (pbvsize s) 0) (pbvmul s s))))
(check-sat)
