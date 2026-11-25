(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= (int_to_pbv (pbvsize s) 0) (pbvmul s (pbvnot (int_to_pbv (pbvsize s) 0)))) (= s (int_to_pbv (pbvsize s) 0))))
(check-sat)
