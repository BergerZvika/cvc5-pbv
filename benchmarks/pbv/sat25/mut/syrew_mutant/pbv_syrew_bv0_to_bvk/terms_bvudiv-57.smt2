(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvshl s (pbvnot (pbvudiv (int_to_pbv (pbvsize s) (pbvsize s)) s))) (int_to_pbv (pbvsize s) 0)))
(check-sat)
