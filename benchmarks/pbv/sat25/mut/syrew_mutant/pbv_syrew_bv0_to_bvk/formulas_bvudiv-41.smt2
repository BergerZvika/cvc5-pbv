(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule (pbvudiv (int_to_pbv (pbvsize s) (pbvsize s)) s) s) (distinct s (int_to_pbv (pbvsize s) 0))))
(check-sat)
