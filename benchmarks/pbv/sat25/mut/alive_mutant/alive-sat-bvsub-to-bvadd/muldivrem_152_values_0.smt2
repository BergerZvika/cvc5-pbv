(set-logic PBV)
(declare-fun %x () PBitVec)
(assert (not (= (pbvmul %x (pbvnot (int_to_pbv (pbvsize %x) 0))) (pbvadd (int_to_pbv (pbvsize %x) 0) %x))))
(check-sat)