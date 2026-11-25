(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvshl s (pbvneg (pbvmul s s))) (int_to_pbv (pbvsize s) 0)))
(check-sat)
