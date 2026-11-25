(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvshl s (pbvnot (pbvudiv s s))) (int_to_pbv (pbvsize s) (pbvsize s))))
(check-sat)
