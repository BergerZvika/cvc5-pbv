(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvudiv s s)) (pbvule s (int_to_pbv (pbvsize s) 1))))
(check-sat)
