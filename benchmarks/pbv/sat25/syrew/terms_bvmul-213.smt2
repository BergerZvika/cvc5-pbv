(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr (pbvshl s s) (pbvmul s s)) (pbvlshr s (pbvand s (pbvnot (int_to_pbv (pbvsize s) 1))))))
(check-sat)
