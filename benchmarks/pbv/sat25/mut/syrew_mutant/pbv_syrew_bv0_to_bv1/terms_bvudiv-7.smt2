(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvshl s (pbvudiv (int_to_pbv (pbvsize s) 1) s)) s))
(check-sat)
