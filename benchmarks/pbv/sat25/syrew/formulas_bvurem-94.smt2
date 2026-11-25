(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvshl s (pbvurem s (int_to_pbv (pbvsize s) 0)))) (pbvule s (pbvshl s s))))
(check-sat)
