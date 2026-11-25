(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvshl (int_to_pbv (pbvsize s) 1) s)) (pbvshl s s)))
(check-sat)
