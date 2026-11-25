(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem (int_to_pbv (pbvsize s) 1) (pbvor s (int_to_pbv (pbvsize s) 1))) (pbvand (int_to_pbv (pbvsize s) 1) (pbvnot s))))
(check-sat)
