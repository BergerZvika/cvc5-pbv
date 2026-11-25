(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
Bit-vector benchmarks from Dawson Engler's tool contributed by Vijay Ganesh
(vganesh@stanford.edu).  Translated into SMT-LIB format by Clark Barrett using
CVC3.

|)
(set-info :category "industrial")
(declare-fun n () PBitVec)
(declare-fun c () PBitVec)
(assert (not (pbvult n (int_to_pbv (pbvsize n) 16))))
(check-sat)
(exit)
