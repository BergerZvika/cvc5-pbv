(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct (int_to_pbv (pbvsize s) 1) (pbvudiv (int_to_pbv (pbvsize s) (pbvsize s)) s)) (= s s)))
(check-sat)
