(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvshl s (pbvudiv s s))) (= s (int_to_pbv (pbvsize s) (pbvsize s)))))
(check-sat)
