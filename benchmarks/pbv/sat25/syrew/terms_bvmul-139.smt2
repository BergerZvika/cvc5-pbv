(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvlshr (pbvshl (int_to_pbv (pbvsize s) 1) s) s)) (pbvshl s (pbvlshr s (pbvshl s s)))))
(check-sat)
