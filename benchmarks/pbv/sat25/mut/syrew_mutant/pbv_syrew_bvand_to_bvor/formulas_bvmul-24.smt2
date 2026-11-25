(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvmul s (pbvor s (int_to_pbv (pbvsize s) 1)))) (distinct s s)))
(check-sat)
