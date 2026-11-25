(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
Bit-vector benchmarks from Dawson Engler's tool contributed by Vijay Ganesh
(vganesh@stanford.edu).  Translated into SMT-LIB format by Clark Barrett using
CVC3.

|)
(set-info :category "industrial")
(declare-fun x () PBitVec)
(assert (not (pbvslt (int_to_pbv (pbvsize x) 0) (pbvshl x (int_to_pbv (pbvsize x) 1)))))
(check-sat)
(exit)