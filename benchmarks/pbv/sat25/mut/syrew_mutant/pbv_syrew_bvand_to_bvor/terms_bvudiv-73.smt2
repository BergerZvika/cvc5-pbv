(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvor s (pbvudiv s (pbvnot (int_to_pbv (pbvsize s) 1)))) (pbvudiv s (pbvnot (int_to_pbv (pbvsize s) 0)))))
(check-sat)
