(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct (int_to_pbv (pbvsize s) (pbvsize s)) (pbvmul s (pbvshl s s))) (pbvult s (pbvmul s (pbvshl s s)))))
(check-sat)
