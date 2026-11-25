(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= (int_to_pbv (pbvsize s) 0) (pbvmul s (pbvneg s))) (= s (pbvshl s (pbvnot s)))))
(check-sat)
