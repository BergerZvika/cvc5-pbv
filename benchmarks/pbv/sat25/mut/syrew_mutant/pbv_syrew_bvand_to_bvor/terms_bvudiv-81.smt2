(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvudiv s (pbvudiv s (pbvor s (int_to_pbv (pbvsize s) 1)))) (pbvand s (int_to_pbv (pbvsize s) 1))))
(check-sat)
