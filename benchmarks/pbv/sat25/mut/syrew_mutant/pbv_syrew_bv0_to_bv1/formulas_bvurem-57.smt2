(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvnot (pbvurem s (int_to_pbv (pbvsize s) 1)))) (pbvult s (pbvnot s))))
(check-sat)
