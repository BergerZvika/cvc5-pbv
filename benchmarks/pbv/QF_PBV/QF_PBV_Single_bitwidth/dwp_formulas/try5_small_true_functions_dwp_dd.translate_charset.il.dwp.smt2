(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
Ivan Jager <aij+nospam@andrew.cmu.edu>

|)
(set-info :category "industrial")
(declare-fun t_252 () PBitVec)
(declare-fun t_251 () PBitVec)
(declare-fun t_250 () PBitVec)
(declare-fun t_249 () PBitVec)
(declare-fun t_248 () PBitVec)
(assert (= (int_to_pbv (pbvsize t_252) 1) (pbvand (pbvand (pbvand (pbvand (pbvand (ite (= t_252 (pbvor t_249 (pbvand t_251 t_250))) (int_to_pbv (pbvsize t_252) 1) (int_to_pbv (pbvsize t_252) 0)) (ite (= t_251 (pbvnot (int_to_pbv (pbvsize t_252) 0))) (int_to_pbv (pbvsize t_252) 1) (int_to_pbv (pbvsize t_252) 0))) (ite (= t_250 t_248) (int_to_pbv (pbvsize t_252) 1) (int_to_pbv (pbvsize t_252) 0))) (ite (= t_249 (int_to_pbv (pbvsize t_252) 0)) (int_to_pbv (pbvsize t_252) 1) (int_to_pbv (pbvsize t_252) 0))) (ite (= t_248 (int_to_pbv (pbvsize t_252) 0)) (int_to_pbv (pbvsize t_252) 1) (int_to_pbv (pbvsize t_252) 0))) (pbvand (pbvnot (pbvand t_251 (pbvnot t_248))) (pbvand t_252 (int_to_pbv (pbvsize t_252) 1))))))
(check-sat)
(exit)