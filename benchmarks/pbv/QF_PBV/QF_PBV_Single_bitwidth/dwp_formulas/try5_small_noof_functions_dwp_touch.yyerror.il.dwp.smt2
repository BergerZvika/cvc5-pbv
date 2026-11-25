(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
Ivan Jager <aij+nospam@andrew.cmu.edu>

|)
(set-info :category "industrial")
(declare-fun t_124 () PBitVec)
(declare-fun t_123 () PBitVec)
(assert (= (int_to_pbv (pbvsize t_124) 1) (pbvand (pbvand (ite (= t_124 t_123) (int_to_pbv (pbvsize t_124) 1) (int_to_pbv (pbvsize t_124) 0)) (ite (= t_123 (int_to_pbv (pbvsize t_124) 1)) (int_to_pbv (pbvsize t_124) 1) (int_to_pbv (pbvsize t_124) 0))) (pbvand (pbvnot (pbvnot t_123)) (pbvand t_124 (int_to_pbv (pbvsize t_124) 1))))))
(check-sat)
(exit)