(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvudiv s (pbvnot (int_to_pbv (pbvsize s) (pbvsize s))))) (distinct s s)))
(check-sat)
