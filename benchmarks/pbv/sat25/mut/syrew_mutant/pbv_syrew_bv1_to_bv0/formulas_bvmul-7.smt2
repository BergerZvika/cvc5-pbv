(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvult s (pbvmul s (pbvnot (int_to_pbv (pbvsize s) 0)))) (pbvult s (pbvshl s (int_to_pbv (pbvsize s) 0)))))
(check-sat)
