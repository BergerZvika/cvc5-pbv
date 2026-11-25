(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= (int_to_pbv (pbvsize s) (pbvsize s)) (pbvmul s (pbvnot s))) (= s (pbvshl s (pbvnot s)))))
(check-sat)
