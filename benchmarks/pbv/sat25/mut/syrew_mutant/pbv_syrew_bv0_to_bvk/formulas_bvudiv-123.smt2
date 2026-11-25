(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvshl s (pbvudiv (int_to_pbv (pbvsize s) (pbvsize s)) s))) (distinct s s)))
(check-sat)
