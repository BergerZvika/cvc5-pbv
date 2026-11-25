(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
Ivan Jager <aij+nospam@andrew.cmu.edu>

|)
(set-info :category "industrial")
(declare-fun t_166 () PBitVec)
(declare-fun t_165 () PBitVec)
(assert (= (int_to_pbv (pbvsize t_166) 1) (pbvand (pbvand (ite (= t_165 (int_to_pbv (pbvsize t_166) 1)) (int_to_pbv (pbvsize t_166) 1) (int_to_pbv (pbvsize t_166) 0)) (ite (= t_166 t_165) (int_to_pbv (pbvsize t_166) 1) (int_to_pbv (pbvsize t_166) 0))) (pbvand (pbvnot (pbvnot t_165)) (pbvand t_166 (int_to_pbv (pbvsize t_166) 1))))))
(check-sat)
(exit)