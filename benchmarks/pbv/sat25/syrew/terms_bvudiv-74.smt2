(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvand s (pbvudiv s (pbvshl s s))) (pbvlshr s (pbvshl s s))))
(check-sat)
