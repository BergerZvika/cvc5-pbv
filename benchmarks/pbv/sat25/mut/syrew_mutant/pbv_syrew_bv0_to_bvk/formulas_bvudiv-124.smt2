(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvshl s (pbvudiv (int_to_pbv (pbvsize s) (pbvsize s)) s))) (= s s)))
(check-sat)
