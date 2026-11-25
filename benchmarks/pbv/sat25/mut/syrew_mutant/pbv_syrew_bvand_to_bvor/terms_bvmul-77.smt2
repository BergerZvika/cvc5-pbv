(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvor s (pbvlshr (int_to_pbv (pbvsize s) 1) (pbvmul s s))) (int_to_pbv (pbvsize s) 0)))
(check-sat)
