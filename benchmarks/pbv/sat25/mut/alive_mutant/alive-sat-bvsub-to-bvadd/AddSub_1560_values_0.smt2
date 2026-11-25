(set-logic PBV)
(declare-fun %a () PBitVec)
(assert (not (= (pbvadd (pbvnot (int_to_pbv (pbvsize %a) 0)) %a) (pbvxor %a (pbvnot (int_to_pbv (pbvsize %a) 0))))))
(check-sat)