(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
 Patrice Godefroid, SAGE (systematic dynamic test generation)
 For more information: http://research.microsoft.com/en-us/um/people/pg/public_psfiles/ndss2008.pdf
|)
(set-info :category "industrial")
(declare-fun T1_11602 () PBitVec)
(declare-fun T1_12047 () PBitVec)
(assert (= (pbvsize T1_11602) (pbvsize T1_12047)))
(assert (and true (= (pzero_extend (pbvsize T1_11602) T1_12047) (pzero_extend (pbvsize T1_11602) T1_11602))))
(check-sat)
(exit)
