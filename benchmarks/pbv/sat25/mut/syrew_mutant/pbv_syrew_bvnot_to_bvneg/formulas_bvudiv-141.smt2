(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvudiv s (pbvlshr (int_to_pbv (pbvsize s) 1) s))) (distinct s (pbvneg (pbvudiv (int_to_pbv (pbvsize s) 0) s)))))
(check-sat)
