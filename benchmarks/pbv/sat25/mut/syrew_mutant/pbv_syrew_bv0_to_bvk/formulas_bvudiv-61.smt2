(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct s (pbvudiv s (pbvnot (int_to_pbv (pbvsize s) (pbvsize s))))) (distinct s (int_to_pbv (pbvsize s) 0))))
(check-sat)
