(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand (pbvmul s s) (pbvshl (int_to_pbv (pbvsize s) 0) (int_to_pbv (pbvsize s) 1))) (int_to_pbv (pbvsize s) 0)))
(check-sat)
