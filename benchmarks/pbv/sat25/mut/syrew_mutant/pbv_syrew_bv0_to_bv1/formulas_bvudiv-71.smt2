(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvudiv s (pbvshl s s))) (= (int_to_pbv (pbvsize s) 1) (pbvshl s s))))
(check-sat)
