(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
Ivan Jager <aij+nospam@andrew.cmu.edu>

|)
(set-info :category "industrial")
(declare-fun t_164 () PBitVec)
(declare-fun t_163 () PBitVec)
(declare-fun t_162 () PBitVec)
(assert (let ((?v_0 (pbvnot (int_to_pbv (pbvsize t_164) 0)))) (= (int_to_pbv (pbvsize t_164) 1) (pbvand (pbvand (ite (= t_162 (int_to_pbv (pbvsize t_164) 0)) (int_to_pbv (pbvsize t_164) 1) (int_to_pbv (pbvsize t_164) 0)) (pbvand (ite (= t_163 ?v_0) (int_to_pbv (pbvsize t_164) 1) (int_to_pbv (pbvsize t_164) 0)) (ite (= t_164 (pbvor t_162 t_163)) (int_to_pbv (pbvsize t_164) 1) (int_to_pbv (pbvsize t_164) 0)))) (pbvand ?v_0 (pbvand t_164 (int_to_pbv (pbvsize t_164) 1)))))))
(check-sat)
(exit)