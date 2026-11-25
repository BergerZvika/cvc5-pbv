(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvor (int_to_pbv (pbvsize s) 1) (pbvlshr (pbvmul s s) (int_to_pbv (pbvsize s) 1))) (int_to_pbv (pbvsize s) 0)))
(check-sat)
