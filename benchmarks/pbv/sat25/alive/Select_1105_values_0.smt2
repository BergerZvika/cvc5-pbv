(set-logic PBV)
(declare-fun %Y () PBitVec)
(assert (not (= %Y %Y)))
(check-sat)