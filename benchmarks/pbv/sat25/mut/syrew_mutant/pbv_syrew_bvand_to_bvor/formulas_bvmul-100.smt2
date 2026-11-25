(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvor (int_to_pbv (pbvsize s) 1) (pbvmul s s))) (distinct s s)))
(check-sat)
