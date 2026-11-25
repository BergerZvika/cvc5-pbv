(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvudiv s (pbvnot (int_to_pbv (pbvsize s) 0)))) (distinct s s)))
(check-sat)
