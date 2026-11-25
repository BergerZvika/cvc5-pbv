(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvmul s (pbvneg (int_to_pbv (pbvsize s) 0)))) (pbvult s (pbvshl s (int_to_pbv (pbvsize s) 1)))))
(check-sat)
