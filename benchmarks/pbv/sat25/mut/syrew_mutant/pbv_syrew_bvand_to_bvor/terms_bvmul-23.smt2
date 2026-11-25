(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvmul s (pbvmul s s))) (pbvor s (int_to_pbv (pbvsize s) 1))))
(check-sat)
