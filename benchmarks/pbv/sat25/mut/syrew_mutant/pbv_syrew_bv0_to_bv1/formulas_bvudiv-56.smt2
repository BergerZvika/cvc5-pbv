(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvshl s (pbvnot s))) (= s (pbvnot (pbvudiv (int_to_pbv (pbvsize s) 1) s)))))
(check-sat)
