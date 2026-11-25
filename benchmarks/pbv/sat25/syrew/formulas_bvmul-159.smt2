(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvshl (pbvand s (int_to_pbv (pbvsize s) 1)) s)) (pbvule s (pbvmul s (pbvshl s s)))))
(check-sat)
