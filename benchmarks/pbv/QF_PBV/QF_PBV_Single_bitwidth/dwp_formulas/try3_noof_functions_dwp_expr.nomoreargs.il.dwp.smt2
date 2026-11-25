(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
Ivan Jager <aij+nospam@andrew.cmu.edu>

|)
(set-info :category "industrial")
(declare-fun t_147 () PBitVec)
(declare-fun t_146 () PBitVec)
(assert (= (int_to_pbv (pbvsize t_147) 1) (pbvand (pbvand (ite (= t_146 (int_to_pbv (pbvsize t_147) 1)) (int_to_pbv (pbvsize t_147) 1) (int_to_pbv (pbvsize t_147) 0)) (ite (= t_147 t_146) (int_to_pbv (pbvsize t_147) 1) (int_to_pbv (pbvsize t_147) 0))) (pbvand (pbvnot (pbvnot t_146)) (pbvand t_147 (int_to_pbv (pbvsize t_147) 1))))))
(check-sat)
(exit)