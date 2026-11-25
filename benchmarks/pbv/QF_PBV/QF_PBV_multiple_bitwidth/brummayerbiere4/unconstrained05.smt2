(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
This benchmark demonstrates the need for propagating unconstrained bit-vectors.

Contributed by Robert Brummayer (robert.brummayer@gmail.com)
|)
(set-info :category "crafted")
(declare-fun v1 () PBitVec)
(declare-fun v3 () PBitVec)
(declare-fun v2 () PBitVec)
(declare-fun v5 () PBitVec)
(declare-fun v4 () PBitVec)
(declare-fun v6 () PBitVec)
(assert (= (pbvsize v1) (pbvsize v3) (pbvsize v2) (pbvsize v5) (pbvsize v4) (pbvsize v6)))
(assert (not (= (ite (not (= (pbvmul (pbvudiv (pbvudiv v4 v3) (pbvmul v2 v5)) (pbvmul (pbvudiv (pbvudiv v1 v2) (pbvudiv v1 v3)) (pbvmul (pbvudiv v2 v3) (pbvmul v4 v5)))) v6)) (int_to_pbv 1 1) (int_to_pbv 1 0)) (int_to_pbv (pbvsize (ite (not (= (pbvmul (pbvudiv (pbvudiv v4 v3) (pbvmul v2 v5)) (pbvmul (pbvudiv (pbvudiv v1 v2) (pbvudiv v1 v3)) (pbvmul (pbvudiv v2 v3) (pbvmul v4 v5)))) v6)) (int_to_pbv 1 1) (int_to_pbv 1 0))) 0))))
(check-sat)
(exit)
