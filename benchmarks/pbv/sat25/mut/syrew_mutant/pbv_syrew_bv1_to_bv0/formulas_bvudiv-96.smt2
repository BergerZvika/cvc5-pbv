(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvudiv s (pbvshl s (int_to_pbv (pbvsize s) 0)))) (distinct s s)))
(check-sat)
