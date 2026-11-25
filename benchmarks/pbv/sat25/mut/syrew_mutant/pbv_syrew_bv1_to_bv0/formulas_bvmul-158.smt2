(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvshl (pbvand s (int_to_pbv (pbvsize s) 0)) s)) (pbvult s (pbvmul s (pbvshl s s)))))
(check-sat)
