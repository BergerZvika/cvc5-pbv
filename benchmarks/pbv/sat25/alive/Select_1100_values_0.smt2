(set-logic PBV)
(declare-fun %X () PBitVec)
(assert (not (= %X %X)))
(check-sat)