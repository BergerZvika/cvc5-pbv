(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr (int_to_pbv (pbvsize s) 1) (pbvmul s (pbvnot (int_to_pbv (pbvsize s) (pbvsize s))))) (pbvlshr (int_to_pbv (pbvsize s) 1) s)))
(check-sat)
