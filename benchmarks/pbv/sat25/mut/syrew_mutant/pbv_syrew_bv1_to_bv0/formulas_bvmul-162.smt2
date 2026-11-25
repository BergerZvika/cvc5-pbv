(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvule s (pbvshl (pbvlshr s (int_to_pbv (pbvsize s) 0)) s)) (= s (pbvmul s (pbvlshr s (int_to_pbv (pbvsize s) 1))))))
(check-sat)
