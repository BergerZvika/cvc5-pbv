(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvshl s (pbvurem (int_to_pbv (pbvsize s) 1) s))) (= s s)))
(check-sat)
