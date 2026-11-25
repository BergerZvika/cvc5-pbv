(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvudiv s (pbvshl s s))) (= s (pbvnot (int_to_pbv (pbvsize s) (pbvsize s))))))
(check-sat)
