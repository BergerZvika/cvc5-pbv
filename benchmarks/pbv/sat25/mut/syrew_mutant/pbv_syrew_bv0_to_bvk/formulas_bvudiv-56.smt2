(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvshl s (pbvnot s))) (= s (pbvnot (pbvudiv (int_to_pbv (pbvsize s) (pbvsize s)) s)))))
(check-sat)
