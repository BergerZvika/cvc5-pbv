(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvurem s (pbvneg (int_to_pbv (pbvsize s) 1)))) (pbvule (pbvnot s) (int_to_pbv (pbvsize s) 1))))
(check-sat)
