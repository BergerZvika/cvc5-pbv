(set-logic PBV)
(declare-fun %X () PBitVec)
(assert (not (= (pbvsgt %X (pbvnot (int_to_pbv (pbvsize %X) 0))) (= (pbvand %X (pbvshl (int_to_pbv (pbvsize %X) 1) (pbvsub (int_to_pbv (pbvsize %X) 0) (int_to_pbv (pbvsize %X) 1)))) (int_to_pbv (pbvsize %X) 0)))))
(check-sat)