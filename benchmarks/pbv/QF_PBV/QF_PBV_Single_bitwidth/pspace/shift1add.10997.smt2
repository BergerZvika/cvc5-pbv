(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
We verify that there exists no y != x with (x + y) = (x << 1).
Contributed by Andreas Froehlich, Gergely Kovasznai, Armin Biere
Institute for Formal Models and Verification, JKU, Linz, 2013
source: http://fmv.jku.at/smtbench and "Efficiently Solving Bit-Vector Problems Using Model Checkers" by Andreas Froehlich, Gergely Kovasznai, Armin Biere. In Proc. 11th Intl. Workshop on Satisfiability Modulo Theories (SMT'13), pages 6-15, aff. to SAT'13, Helsinki, Finland, 2013.
|)
(set-info :category "crafted")
(declare-fun x () PBitVec)
(declare-fun y () PBitVec)
(declare-fun z () PBitVec)
(assert (= z (pbvadd x y)))
(assert (= z (pbvshl x (int_to_pbv (pbvsize x) 1))))
(assert (distinct x y))
(check-sat)
(exit)