(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
Bit-vector benchmarks from Dawson Engler's tool contributed by Vijay Ganesh
(vganesh@stanford.edu).  Translated into SMT-LIB format by Clark Barrett using
CVC3.

|)
(set-info :category "industrial")
(declare-fun smt_fresh_symbolic_value () PBitVec)
(declare-fun smt_fresh_symbolic_value_1 () PBitVec)
(declare-fun smt_fresh_symbolic_value_2 () PBitVec)
(assert (not (not (= smt_fresh_symbolic_value (int_to_pbv (pbvsize smt_fresh_symbolic_value) 0)))))
(assert (not (not (= smt_fresh_symbolic_value_1 (int_to_pbv (pbvsize smt_fresh_symbolic_value) 0)))))
(assert (not (not (= smt_fresh_symbolic_value_2 (int_to_pbv (pbvsize smt_fresh_symbolic_value) 0)))))
(check-sat)
(exit)