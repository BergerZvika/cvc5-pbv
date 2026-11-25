(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvlshr s (pbvor s (pbvudiv (int_to_pbv (pbvsize s) 1) s))) (pbvlshr s (pbvudiv (int_to_pbv (pbvsize s) 1) s))))
(check-sat)
