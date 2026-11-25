(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul (pbvneg (int_to_pbv (pbvsize s) 0)) (pbvlshr (int_to_pbv (pbvsize s) 1) s)) (pbvmul (pbvnot s) (pbvlshr (int_to_pbv (pbvsize s) 1) s))))
(check-sat)
