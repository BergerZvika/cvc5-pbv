(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvlshr (pbvshl (int_to_pbv (pbvsize s) 1) (int_to_pbv (pbvsize s) 1)) s)) (pbvlshr s (pbvor s (pbvnot (int_to_pbv (pbvsize s) 1))))))
(check-sat)
