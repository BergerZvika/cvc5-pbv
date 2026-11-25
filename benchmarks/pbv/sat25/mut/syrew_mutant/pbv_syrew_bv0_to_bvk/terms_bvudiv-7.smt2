(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvshl s (pbvudiv (int_to_pbv (pbvsize s) (pbvsize s)) s)) s))
(check-sat)
