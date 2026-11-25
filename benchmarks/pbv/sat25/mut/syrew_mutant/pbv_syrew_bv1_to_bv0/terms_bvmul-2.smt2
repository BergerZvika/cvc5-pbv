(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvshl (int_to_pbv (pbvsize s) 0) s)) (pbvshl s s)))
(check-sat)
