(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct (int_to_pbv (pbvsize s) (pbvsize s)) (pbvshl (int_to_pbv (pbvsize s) 1) (pbvmul s s))) (pbvule (pbvmul s s) (int_to_pbv (pbvsize s) 1))))
(check-sat)
