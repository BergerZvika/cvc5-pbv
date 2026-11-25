(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvneg (pbvurem s (int_to_pbv (pbvsize s) 0)))) (pbvult s (pbvnot s))))
(check-sat)
