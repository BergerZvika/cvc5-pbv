(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= (int_to_pbv (pbvsize s) 0) (pbvshl (int_to_pbv (pbvsize s) 1) (pbvmul s s))) (pbvult (int_to_pbv (pbvsize s) 1) (pbvmul s s))))
(check-sat)
