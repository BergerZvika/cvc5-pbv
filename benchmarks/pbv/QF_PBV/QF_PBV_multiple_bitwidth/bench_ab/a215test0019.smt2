(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
Bit-vector benchmarks from Dawson Engler's tool contributed by Vijay Ganesh
(vganesh@stanford.edu).  Translated into SMT-LIB format by Clark Barrett using
CVC3.

|)
(set-info :category "industrial")
(declare-fun k () Int)
(assert (>= k 1))
(declare-fun buffer_0 () PBitVec)
(declare-fun buffer_1 () PBitVec)
(assert (= (pbvsize buffer_0) (pbvsize buffer_1)))
(assert (not (not (= (psign_extend k buffer_0) (int_to_pbv (pbvsize (psign_extend k buffer_0)) 0)))))
(check-sat)
(exit)
