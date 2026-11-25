(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct (int_to_pbv (pbvsize s) 0) (pbvmul s (pbvnot (int_to_pbv (pbvsize s) 0)))) (distinct s (int_to_pbv (pbvsize s) 0))))
(check-sat)
