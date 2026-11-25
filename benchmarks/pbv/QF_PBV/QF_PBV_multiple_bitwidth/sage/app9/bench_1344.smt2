(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
 Patrice Godefroid, SAGE (systematic dynamic test generation)
 For more information: http://research.microsoft.com/en-us/um/people/pg/public_psfiles/ndss2008.pdf
|)
(set-info :category "industrial")
(declare-fun k () Int)
(assert (>= k 1))
(declare-fun T1_4439 () PBitVec)
(assert (and true (= (pzero_extend k T1_4439) (int_to_pbv (pbvsize (pzero_extend k T1_4439)) 1))))
(check-sat)
(exit)
