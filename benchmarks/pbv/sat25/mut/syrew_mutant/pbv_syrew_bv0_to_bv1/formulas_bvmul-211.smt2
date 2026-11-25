(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct (int_to_pbv (pbvsize s) 1) (pbvmul s (pbvnot s))) (distinct s (pbvshl s (pbvnot s)))))
(check-sat)
