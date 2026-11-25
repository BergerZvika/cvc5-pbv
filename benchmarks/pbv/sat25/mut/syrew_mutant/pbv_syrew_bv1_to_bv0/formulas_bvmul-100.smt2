(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvand (int_to_pbv (pbvsize s) 0) (pbvmul s s))) (distinct s s)))
(check-sat)
