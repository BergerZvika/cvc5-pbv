(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr s (pbvnot (pbvmul s s))) (int_to_pbv (pbvsize s) 1)))
(check-sat)
