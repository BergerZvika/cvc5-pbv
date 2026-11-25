(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvudiv (int_to_pbv (pbvsize s) 1) (pbvshl s s)) (pbvudiv s (pbvshl s s))))
(check-sat)
