(set-info :smt-lib-version 2.6)
(set-logic PBV)
(declare-fun pbv_w_1 () Int)
(assert (>= pbv_w_1 1))
(set-info :source |
Bit-vector benchmarks from Dawson Engler's tool contributed by Vijay Ganesh
(vganesh@stanford.edu).  Translated into SMT-LIB format by Clark Barrett using
CVC3.

|)
(set-info :category "industrial")
(set-info :status sat)
(declare-fun x () PBitVec)
(assert (pbvslt (int_to_pbv (pbvsize (pextract (pconcat x (int_to_pbv pbv_w_1 0)) (- (pbvsize (pconcat x (int_to_pbv pbv_w_1 0))) 1) 0)) 0) (pextract (pconcat x (int_to_pbv pbv_w_1 0)) (- (pbvsize (pconcat x (int_to_pbv pbv_w_1 0))) 1) 0)))
(check-sat)
(exit)