(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvudiv (int_to_pbv (pbvsize s) 0) s)) (distinct s s)))
(check-sat)
