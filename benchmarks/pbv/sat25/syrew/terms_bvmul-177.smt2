(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand (int_to_pbv (pbvsize s) 1) (pbvmul s (pbvnot s))) (int_to_pbv (pbvsize s) 0)))
(check-sat)
