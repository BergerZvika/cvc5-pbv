(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvshl s (pbvlshr (int_to_pbv (pbvsize s) 0) (pbvlshr s (int_to_pbv (pbvsize s) 1)))) (pbvshl s (pbvudiv (int_to_pbv (pbvsize s) 1) s))))
(check-sat)
