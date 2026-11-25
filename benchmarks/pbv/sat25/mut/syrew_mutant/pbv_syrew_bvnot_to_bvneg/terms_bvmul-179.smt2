(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr (int_to_pbv (pbvsize s) 1) (pbvmul s (pbvneg (int_to_pbv (pbvsize s) 0)))) (pbvlshr (int_to_pbv (pbvsize s) 1) s)))
(check-sat)
