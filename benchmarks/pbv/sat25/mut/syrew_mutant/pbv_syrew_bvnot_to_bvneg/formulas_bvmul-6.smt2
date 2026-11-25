(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvmul s (pbvneg (int_to_pbv (pbvsize s) 0)))) (= (int_to_pbv (pbvsize s) 0) (pbvshl s (int_to_pbv (pbvsize s) 1)))))
(check-sat)
