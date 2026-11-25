(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
 Patrice Godefroid, SAGE (systematic dynamic test generation)
 For more information: http://research.microsoft.com/en-us/um/people/pg/public_psfiles/ndss2008.pdf
|)
(set-info :category "industrial")
(declare-fun T1_10546 () PBitVec)
(assert (and true (= (psign_extend (pbvsize T1_10546) T1_10546) (int_to_pbv (pbvsize (psign_extend (pbvsize T1_10546) T1_10546)) 0)) (not (= T1_10546 (int_to_pbv (pbvsize T1_10546) 0)))))
(check-sat)
(exit)
