(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul (pbvnot (int_to_pbv (pbvsize s) 1)) (pbvshl s (int_to_pbv (pbvsize s) 1))) (pbvmul s (pbvnot (int_to_pbv (pbvsize s) 1)))))
(check-sat)
