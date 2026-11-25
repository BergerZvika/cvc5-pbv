(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
 Patrice Godefroid, SAGE (systematic dynamic test generation)
 For more information: http://research.microsoft.com/en-us/um/people/pg/public_psfiles/ndss2008.pdf
|)
(set-info :category "industrial")
(declare-fun T1_2591 () PBitVec)
(assert (and true (= (pzero_extend (pbvsize T1_2591) T1_2591) (int_to_pbv (pbvsize (pzero_extend (pbvsize T1_2591) T1_2591)) 0))))
(check-sat)
(exit)
