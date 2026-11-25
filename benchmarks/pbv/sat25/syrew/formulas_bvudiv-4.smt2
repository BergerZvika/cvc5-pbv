(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvudiv (int_to_pbv (pbvsize s) 0) s)) (= s s)))
(check-sat)
