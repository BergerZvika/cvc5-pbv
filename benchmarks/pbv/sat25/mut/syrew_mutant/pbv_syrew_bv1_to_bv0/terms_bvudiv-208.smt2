(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvudiv (int_to_pbv (pbvsize s) 0) (pbvshl s (int_to_pbv (pbvsize s) 0)))) (pbvand s (pbvshl s (pbvshl s (int_to_pbv (pbvsize s) 1))))))
(check-sat)
