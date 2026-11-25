(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvudiv s (pbvshl s s))) (= (int_to_pbv (pbvsize s) 0) (pbvshl s s))))
(check-sat)
