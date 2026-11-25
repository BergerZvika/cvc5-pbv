(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule (pbvurem (int_to_pbv (pbvsize s) (pbvsize s)) s) s) (= s s)))
(check-sat)
