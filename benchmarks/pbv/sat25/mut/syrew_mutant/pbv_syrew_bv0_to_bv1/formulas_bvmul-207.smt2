(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct (int_to_pbv (pbvsize s) 1) (pbvnot (pbvmul s s))) (= s s)))
(check-sat)
