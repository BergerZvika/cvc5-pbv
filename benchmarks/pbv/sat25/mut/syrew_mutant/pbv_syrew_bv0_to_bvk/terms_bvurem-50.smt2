(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvurem s (pbvnot (int_to_pbv (pbvsize s) (pbvsize s))))) (pbvlshr s (pbvurem s (pbvnot (int_to_pbv (pbvsize s) 0))))))
(check-sat)
