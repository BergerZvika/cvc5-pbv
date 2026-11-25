(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
 Patrice Godefroid, SAGE (systematic dynamic test generation)
 For more information: http://research.microsoft.com/en-us/um/people/pg/public_psfiles/ndss2008.pdf
|)
(set-info :category "industrial")
(declare-fun T1_572860 () PBitVec)
(assert (and true (not (= (pbvand T1_572860 (int_to_pbv (pbvsize T1_572860) 1)) (int_to_pbv (pbvsize T1_572860) 0)))))
(check-sat)
(exit)