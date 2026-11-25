(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvnot (pbvurem s (int_to_pbv (pbvsize s) (pbvsize s))))) (distinct s s)))
(check-sat)
