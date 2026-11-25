(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (distinct (int_to_pbv (pbvsize s) 0) (pbvshl s (pbvshl s s))) (distinct s (pbvmul s (pbvlshr s (int_to_pbv (pbvsize s) 1))))))
(check-sat)
