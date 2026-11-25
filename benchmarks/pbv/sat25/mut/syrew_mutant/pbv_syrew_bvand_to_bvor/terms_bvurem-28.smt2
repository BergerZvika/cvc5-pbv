(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem (pbvor s (int_to_pbv (pbvsize s) 1)) s) (pbvand s (pbvurem (int_to_pbv (pbvsize s) 1) s))))
(check-sat)
