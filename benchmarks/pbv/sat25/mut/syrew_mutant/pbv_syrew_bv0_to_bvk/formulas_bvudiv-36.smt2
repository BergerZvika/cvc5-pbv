(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule (pbvudiv s s) s) (distinct s (int_to_pbv (pbvsize s) (pbvsize s)))))
(check-sat)
