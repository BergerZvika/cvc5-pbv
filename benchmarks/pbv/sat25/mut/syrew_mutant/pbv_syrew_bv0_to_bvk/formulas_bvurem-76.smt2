(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvurem s (pbvnot (int_to_pbv (pbvsize s) (pbvsize s))))) (distinct s (pbvnot (int_to_pbv (pbvsize s) 0)))))
(check-sat)
