(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvneg (pbvudiv (int_to_pbv (pbvsize s) 1) s))) (= s s)))
(check-sat)
