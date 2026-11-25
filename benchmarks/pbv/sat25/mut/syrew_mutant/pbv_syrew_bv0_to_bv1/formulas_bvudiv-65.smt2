(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvudiv s (pbvnot (int_to_pbv (pbvsize s) 1)))) (distinct s (int_to_pbv (pbvsize s) 1))))
(check-sat)
