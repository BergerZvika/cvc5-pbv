(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
 Patrice Godefroid, SAGE (systematic dynamic test generation)
 For more information: http://research.microsoft.com/en-us/um/people/pg/public_psfiles/ndss2008.pdf
|)
(set-info :category "industrial")
(declare-fun T1_6527 () PBitVec)
(declare-fun T1_6971 () PBitVec)
(assert (= (pbvsize T1_6527) (pbvsize T1_6971)))
(assert (and true (= (pzero_extend (pbvsize T1_6527) T1_6971) (pzero_extend (pbvsize T1_6527) T1_6527))))
(check-sat)
(exit)
