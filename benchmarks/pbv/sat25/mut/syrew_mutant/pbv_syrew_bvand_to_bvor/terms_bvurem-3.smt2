(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvor s (pbvurem s (int_to_pbv (pbvsize s) 0))) s))
(check-sat)
