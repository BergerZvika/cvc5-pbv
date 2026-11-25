(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvshl s (pbvurem (int_to_pbv (pbvsize s) (pbvsize s)) s))) (distinct s s)))
(check-sat)
