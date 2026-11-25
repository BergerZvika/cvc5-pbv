(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvshl (int_to_pbv (pbvsize s) 1) (pbvshl s (pbvshl (int_to_pbv (pbvsize s) 1) (int_to_pbv (pbvsize s) 1)))) (pbvlshr (int_to_pbv (pbvsize s) 1) (pbvmul s s))))
(check-sat)
