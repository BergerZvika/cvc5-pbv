(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvshl s (pbvudiv (int_to_pbv (pbvsize s) 0) s)) s))
(check-sat)
