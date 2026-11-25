(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (= s (pbvshl s (pbvmul s s))) (= (int_to_pbv (pbvsize s) 1) (pbvmul s s))))
(check-sat)
