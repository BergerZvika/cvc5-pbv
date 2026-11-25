(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct (int_to_pbv (pbvsize s) 0) (pbvshl s (pbvshl (int_to_pbv (pbvsize s) 0) (int_to_pbv (pbvsize s) 1)))) (distinct (int_to_pbv (pbvsize s) 0) (pbvmul s s))))
(check-sat)
