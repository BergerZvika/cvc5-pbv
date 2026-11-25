(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvudiv s (pbvneg (int_to_pbv (pbvsize s) 0)))) (distinct s (int_to_pbv (pbvsize s) 0))))
(check-sat)
