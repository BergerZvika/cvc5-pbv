(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
Ivan Jager <aij+nospam@andrew.cmu.edu>

|)
(set-info :category "industrial")
(declare-fun t_452 () PBitVec)
(declare-fun t_451 () PBitVec)
(declare-fun t_450 () PBitVec)
(declare-fun t_449 () PBitVec)
(declare-fun t_448 () PBitVec)
(assert (= (int_to_pbv (pbvsize t_452) 1) (pbvand (pbvand (pbvand (pbvand (pbvand (ite (= t_452 (pbvor t_449 (pbvand t_451 t_450))) (int_to_pbv (pbvsize t_452) 1) (int_to_pbv (pbvsize t_452) 0)) (ite (= t_451 (pbvnot (int_to_pbv (pbvsize t_452) 0))) (int_to_pbv (pbvsize t_452) 1) (int_to_pbv (pbvsize t_452) 0))) (ite (= t_450 t_448) (int_to_pbv (pbvsize t_452) 1) (int_to_pbv (pbvsize t_452) 0))) (ite (= t_449 (int_to_pbv (pbvsize t_452) 0)) (int_to_pbv (pbvsize t_452) 1) (int_to_pbv (pbvsize t_452) 0))) (ite (= t_448 (int_to_pbv (pbvsize t_452) 0)) (int_to_pbv (pbvsize t_452) 1) (int_to_pbv (pbvsize t_452) 0))) (pbvand (pbvnot (pbvand t_451 (pbvnot t_448))) (pbvand t_452 (int_to_pbv (pbvsize t_452) 1))))))
(check-sat)
(exit)