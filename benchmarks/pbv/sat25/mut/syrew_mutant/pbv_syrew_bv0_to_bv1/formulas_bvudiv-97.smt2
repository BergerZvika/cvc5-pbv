(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvudiv s (pbvshl s (int_to_pbv (pbvsize s) 1)))) (= (int_to_pbv (pbvsize s) 1) (pbvshl s (int_to_pbv (pbvsize s) 1)))))
(check-sat)
