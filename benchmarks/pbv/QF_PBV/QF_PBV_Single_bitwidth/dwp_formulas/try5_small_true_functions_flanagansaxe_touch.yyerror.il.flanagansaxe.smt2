(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
Ivan Jager <aij+nospam@andrew.cmu.edu>

|)
(set-info :category "industrial")
(declare-fun t_130 () PBitVec)
(declare-fun t_129 () PBitVec)
(declare-fun t_128 () PBitVec)
(declare-fun t_127 () PBitVec)
(declare-fun t_126 () PBitVec)
(declare-fun t_125 () PBitVec)
(declare-fun t_124 () PBitVec)
(declare-fun t_123 () PBitVec)
(declare-fun t_122 () PBitVec)
(assert (= (int_to_pbv (pbvsize t_130) 1) (pbvand (pbvand (pbvand (pbvand (pbvand (pbvand (pbvand (pbvand (pbvand (ite (= t_130 (pbvand t_129 (int_to_pbv (pbvsize t_130) 1))) (int_to_pbv (pbvsize t_130) 1) (int_to_pbv (pbvsize t_130) 0)) (ite (= t_129 (pbvand t_128 (int_to_pbv (pbvsize t_130) 1))) (int_to_pbv (pbvsize t_130) 1) (int_to_pbv (pbvsize t_130) 0))) (ite (= t_128 (pbvand t_127 (int_to_pbv (pbvsize t_130) 1))) (int_to_pbv (pbvsize t_130) 1) (int_to_pbv (pbvsize t_130) 0))) (ite (= t_127 (pbvand t_126 (int_to_pbv (pbvsize t_130) 1))) (int_to_pbv (pbvsize t_130) 1) (int_to_pbv (pbvsize t_130) 0))) (ite (= t_126 (pbvand t_125 (int_to_pbv (pbvsize t_130) 1))) (int_to_pbv (pbvsize t_130) 1) (int_to_pbv (pbvsize t_130) 0))) (ite (= t_125 (pbvand t_124 (int_to_pbv (pbvsize t_130) 1))) (int_to_pbv (pbvsize t_130) 1) (int_to_pbv (pbvsize t_130) 0))) (ite (= t_124 (pbvand t_123 (int_to_pbv (pbvsize t_130) 1))) (int_to_pbv (pbvsize t_130) 1) (int_to_pbv (pbvsize t_130) 0))) (ite (= t_123 (pbvand t_122 (int_to_pbv (pbvsize t_130) 1))) (int_to_pbv (pbvsize t_130) 1) (int_to_pbv (pbvsize t_130) 0))) (ite (= t_122 (int_to_pbv (pbvsize t_130) 1)) (int_to_pbv (pbvsize t_130) 1) (int_to_pbv (pbvsize t_130) 0))) (pbvand (pbvnot (int_to_pbv (pbvsize t_130) 0)) (pbvor (pbvnot (pbvand t_130 (int_to_pbv (pbvsize t_130) 1))) (int_to_pbv (pbvsize t_130) 1))))))
(check-sat)
(exit)