(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvlshr (pbvneg (int_to_pbv (pbvsize s) 1)) s)) (pbvmul s (pbvlshr (pbvnot s) s))))
(check-sat)
