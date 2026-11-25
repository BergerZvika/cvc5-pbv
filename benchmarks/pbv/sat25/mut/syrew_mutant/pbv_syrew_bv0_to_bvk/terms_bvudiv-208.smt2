(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvudiv (int_to_pbv (pbvsize s) (pbvsize s)) (pbvshl s (int_to_pbv (pbvsize s) 1)))) (pbvand s (pbvshl s (pbvshl s (int_to_pbv (pbvsize s) 1))))))
(check-sat)
