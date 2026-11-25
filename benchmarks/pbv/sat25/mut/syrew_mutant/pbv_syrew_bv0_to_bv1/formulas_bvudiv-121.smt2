(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvshl s (pbvudiv (int_to_pbv (pbvsize s) 1) s))) (distinct s s)))
(check-sat)
