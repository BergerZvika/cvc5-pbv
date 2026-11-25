(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvurem (int_to_pbv (pbvsize s) 1) (pbvshl s s))) (int_to_pbv (pbvsize s) (pbvsize s))))
(check-sat)
