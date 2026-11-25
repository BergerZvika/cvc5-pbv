(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvshl s (pbvurem s (int_to_pbv (pbvsize s) 1)))) (pbvult s (pbvshl s s))))
(check-sat)
