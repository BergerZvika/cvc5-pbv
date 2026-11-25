(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
Bit-vector benchmarks from Dawson Engler's tool contributed by Vijay Ganesh
(vganesh@stanford.edu).  Translated into SMT-LIB format by Clark Barrett using
CVC3.

|)
(set-info :category "industrial")
(declare-fun r1 () PBitVec)
(assert (not (not (= r1 (int_to_pbv (pbvsize r1) 0)))))
(check-sat)
(exit)