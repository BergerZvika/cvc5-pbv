(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvshl s (pbvudiv s (pbvand s (int_to_pbv (pbvsize s) 1)))) (pbvshl (pbvand s (int_to_pbv (pbvsize s) 1)) s)))
(check-sat)
