(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvor (int_to_pbv (pbvsize s) 1) (pbvlshr (pbvmul s s) s)) (pbvlshr (pbvmul s s) s)))
(check-sat)
