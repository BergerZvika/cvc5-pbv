(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr s (pbvnot (pbvudiv s s))) (int_to_pbv (pbvsize s) (pbvsize s))))
(check-sat)
