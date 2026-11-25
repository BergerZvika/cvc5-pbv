(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvmul s (pbvlshr (int_to_pbv (pbvsize s) 0) (pbvshl s s))) (pbvlshr s (pbvshl s s))))
(check-sat)
