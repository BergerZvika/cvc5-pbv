(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvshl s (pbvurem (int_to_pbv (pbvsize s) 1) s))) (pbvult s (pbvneg s))))
(check-sat)
