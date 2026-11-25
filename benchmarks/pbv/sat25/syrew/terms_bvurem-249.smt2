(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvlshr (pbvshl s s) s)) (pbvlshr s (pbvshl s s))))
(check-sat)
