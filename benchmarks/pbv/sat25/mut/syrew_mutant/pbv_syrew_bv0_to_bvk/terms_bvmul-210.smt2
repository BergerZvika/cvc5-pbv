(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul (pbvnot (int_to_pbv (pbvsize s) (pbvsize s))) (pbvlshr (int_to_pbv (pbvsize s) 1) s)) (pbvmul (pbvnot s) (pbvlshr (int_to_pbv (pbvsize s) 1) s))))
(check-sat)
