(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
We give a counter-example for (x + 1 <= y) -> (x < y)
Contributed by Andreas Froehlich, Gergely Kovasznai, Armin Biere
Institute for Formal Models and Verification, JKU, Linz, 2013
source: http://fmv.jku.at/smtbench and "Efficiently Solving Bit-Vector Problems Using Model Checkers" by Andreas Froehlich, Gergely Kovasznai, Armin Biere. In Proc. 11th Intl. Workshop on Satisfiability Modulo Theories (SMT'13), pages 6-15, aff. to SAT'13, Helsinki, Finland, 2013.
|)
(set-info :category "crafted")
(declare-fun x () PBitVec)
(declare-fun y () PBitVec)
(assert (pbvuge x y))
(assert (pbvule (pbvadd x (int_to_pbv (pbvsize x) 1)) y))
(check-sat)
(exit)