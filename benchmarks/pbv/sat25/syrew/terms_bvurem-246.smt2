(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvlshr (pbvnot (int_to_pbv (pbvsize s) 1)) s)) (pbvurem s (pbvlshr (pbvnot s) s))))
(check-sat)
