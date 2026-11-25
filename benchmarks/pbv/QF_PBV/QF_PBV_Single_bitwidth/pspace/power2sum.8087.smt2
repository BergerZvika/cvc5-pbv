(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
We verify that the sum of two distinct powers of two cannot be a power of two.
Contributed by Andreas Froehlich, Gergely Kovasznai, Armin Biere
Institute for Formal Models and Verification, JKU, Linz, 2013
source: http://fmv.jku.at/smtbench and "Efficiently Solving Bit-Vector Problems Using Model Checkers" by Andreas Froehlich, Gergely Kovasznai, Armin Biere. In Proc. 11th Intl. Workshop on Satisfiability Modulo Theories (SMT'13), pages 6-15, aff. to SAT'13, Helsinki, Finland, 2013.
|)
(set-info :category "crafted")
(declare-fun x () PBitVec)
(declare-fun y () PBitVec)
(declare-fun z () PBitVec)
(assert (= z (pbvadd x y)))
(assert (distinct x y))
(assert (and (distinct x (int_to_pbv (pbvsize x) 0)) (= (pbvand x (pbvsub x (int_to_pbv (pbvsize x) 1))) (int_to_pbv (pbvsize x) 0))))
(assert (and (distinct y (int_to_pbv (pbvsize x) 0)) (= (pbvand y (pbvsub y (int_to_pbv (pbvsize x) 1))) (int_to_pbv (pbvsize x) 0))))
(assert (and (distinct z (int_to_pbv (pbvsize x) 0)) (= (pbvand z (pbvsub z (int_to_pbv (pbvsize x) 1))) (int_to_pbv (pbvsize x) 0))))
(check-sat)
(exit)