(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
 Patrice Godefroid, SAGE (systematic dynamic test generation)
 For more information: http://research.microsoft.com/en-us/um/people/pg/public_psfiles/ndss2008.pdf
|)
(set-info :category "industrial")
(declare-fun T1_2680 () PBitVec)
(assert (and true (= T1_2680 (int_to_pbv (pbvsize T1_2680) 0))))
(check-sat)
(exit)