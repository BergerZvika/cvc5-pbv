(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvshl (pbvand s (int_to_pbv (pbvsize s) 0)) s) (pbvmul s (pbvshl s s))))
(check-sat)
