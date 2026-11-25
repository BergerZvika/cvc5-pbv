(set-logic PBV)
(declare-fun %X () PBitVec)
(assert (not (= (pbvslt %X (int_to_pbv (pbvsize %X) 0)) (not (= (pbvor %X (pbvshl (int_to_pbv (pbvsize %X) 1) (pbvsub (int_to_pbv (pbvsize %X) (pbvsize %X)) (int_to_pbv (pbvsize %X) 1)))) (int_to_pbv (pbvsize %X) 0))))))
(check-sat)