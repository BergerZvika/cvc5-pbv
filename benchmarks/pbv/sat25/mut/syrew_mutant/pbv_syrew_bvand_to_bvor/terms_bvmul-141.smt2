(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvor s (pbvlshr (pbvshl (int_to_pbv (pbvsize s) 1) s) (int_to_pbv (pbvsize s) 1))) (pbvmul s (pbvlshr (pbvshl s (int_to_pbv (pbvsize s) 1)) s))))
(check-sat)
