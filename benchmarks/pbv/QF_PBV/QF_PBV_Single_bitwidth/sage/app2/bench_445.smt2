(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
 Patrice Godefroid, SAGE (systematic dynamic test generation)
 For more information: http://research.microsoft.com/en-us/um/people/pg/public_psfiles/ndss2008.pdf
|)
(set-info :category "industrial")
(declare-fun T1_10 () PBitVec)
(assert (and true (pbvsle (int_to_pbv (pbvsize T1_10) 0) T1_10)))
(check-sat)
(exit)