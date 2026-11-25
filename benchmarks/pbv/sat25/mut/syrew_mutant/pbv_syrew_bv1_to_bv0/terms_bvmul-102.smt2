(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvlshr (pbvnot (int_to_pbv (pbvsize s) 0)) s)) (pbvmul s (pbvlshr (pbvnot s) s))))
(check-sat)
