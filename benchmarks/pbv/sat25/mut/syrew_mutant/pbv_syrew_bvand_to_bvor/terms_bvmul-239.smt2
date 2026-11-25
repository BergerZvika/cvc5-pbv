(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvor (pbvmul s s) (pbvshl (int_to_pbv (pbvsize s) 1) s)) (pbvshl (pbvlshr s (int_to_pbv (pbvsize s) 1)) s)))
(check-sat)
