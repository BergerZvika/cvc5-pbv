(set-logic PBV)
(declare-fun s () PBitVec)
(assert (distinct (pbvurem s (pbvshl s s)) s))
(check-sat)
