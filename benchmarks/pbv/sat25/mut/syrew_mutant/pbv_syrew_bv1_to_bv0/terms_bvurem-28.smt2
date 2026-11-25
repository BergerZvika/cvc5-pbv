(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem (pbvand s (int_to_pbv (pbvsize s) 0)) s) (pbvand s (pbvurem (int_to_pbv (pbvsize s) 1) s))))
(check-sat)
