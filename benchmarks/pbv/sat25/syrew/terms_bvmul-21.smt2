(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvmul s (pbvshl s s))) (int_to_pbv (pbvsize s) 0)))
(check-sat)
