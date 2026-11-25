(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvlshr s (pbvshl s (int_to_pbv (pbvsize s) 1)))) (pbvlshr s (pbvshl s (pbvor s (int_to_pbv (pbvsize s) 1))))))
(check-sat)
