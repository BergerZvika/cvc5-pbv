(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
 Patrice Godefroid, SAGE (systematic dynamic test generation)
 For more information: http://research.microsoft.com/en-us/um/people/pg/public_psfiles/ndss2008.pdf
|)
(set-info :category "industrial")
(declare-fun T1_16679 () PBitVec)
(declare-fun T1_17123 () PBitVec)
(assert (= (pbvsize T1_16679) (pbvsize T1_17123)))
(assert (and true (= (pzero_extend (pbvsize T1_16679) T1_17123) (pzero_extend (pbvsize T1_16679) T1_16679))))
(check-sat)
(exit)
