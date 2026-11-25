(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct (int_to_pbv (pbvsize s) 0) (pbvmul s (pbvshl s s))) (pbvult s (pbvmul s (pbvshl s s)))))
(check-sat)
