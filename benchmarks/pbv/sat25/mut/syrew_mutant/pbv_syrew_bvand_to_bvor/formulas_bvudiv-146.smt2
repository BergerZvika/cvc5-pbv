(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvor s (pbvudiv (int_to_pbv (pbvsize s) 1) s))) (pbvule s (int_to_pbv (pbvsize s) 1))))
(check-sat)
