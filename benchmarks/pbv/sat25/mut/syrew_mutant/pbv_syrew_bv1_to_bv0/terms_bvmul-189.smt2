(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr (int_to_pbv (pbvsize s) 0) (pbvmul s (pbvshl s (int_to_pbv (pbvsize s) 1)))) (pbvlshr (int_to_pbv (pbvsize s) 1) (pbvmul s s))))
(check-sat)
