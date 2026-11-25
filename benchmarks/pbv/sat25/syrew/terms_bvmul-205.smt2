(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvshl (int_to_pbv (pbvsize s) 1) (pbvshl (pbvlshr s (int_to_pbv (pbvsize s) 1)) s)) (pbvlshr (int_to_pbv (pbvsize s) 1) (pbvlshr (pbvmul s s) s))))
(check-sat)
