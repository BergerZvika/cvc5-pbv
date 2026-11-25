(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand (int_to_pbv (pbvsize s) 1) (pbvnot (pbvmul s s))) (pbvand (int_to_pbv (pbvsize s) 1) (pbvnot s))))
(check-sat)
