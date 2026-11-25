(set-logic PBV)
(declare-fun %a () PBitVec)
(assert (not (= (pbvsub (pbvnot (int_to_pbv (pbvsize %a) 1)) %a) (pbvxor %a (pbvnot (int_to_pbv (pbvsize %a) 0))))))
(check-sat)