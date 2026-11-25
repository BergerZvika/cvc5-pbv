(set-logic PBV)
(declare-fun %x () PBitVec)
(assert (not (= (pbvmul %x (pbvneg (int_to_pbv (pbvsize %x) 0))) (pbvsub (int_to_pbv (pbvsize %x) 0) %x))))
(check-sat)