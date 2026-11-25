(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvshl (pbvor s (int_to_pbv (pbvsize s) 1)) s) (pbvmul s (pbvshl s s))))
(check-sat)
