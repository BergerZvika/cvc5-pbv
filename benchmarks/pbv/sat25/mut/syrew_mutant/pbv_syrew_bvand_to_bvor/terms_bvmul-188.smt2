(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr (int_to_pbv (pbvsize s) 1) (pbvmul s (pbvor s (int_to_pbv (pbvsize s) 1)))) (pbvand (int_to_pbv (pbvsize s) 1) (pbvnot s))))
(check-sat)
