(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvnot (pbvurem s (int_to_pbv (pbvsize s) 1)))) (pbvult s (pbvnot s))))
(check-sat)
