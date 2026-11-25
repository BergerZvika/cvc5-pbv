(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvnot (pbvlshr (int_to_pbv (pbvsize s) 0) s))) (pbvmul s (pbvnot (int_to_pbv (pbvsize s) 0)))))
(check-sat)
