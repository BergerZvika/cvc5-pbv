(set-info :smt-lib-version 2.6)
(set-logic PBV)
(set-info :source |
Ivan Jager <aij+nospam@andrew.cmu.edu>

|)
(set-info :category "industrial")
(declare-fun t_96 () PBitVec)
(declare-fun t_95 () PBitVec)
(declare-fun t_94 () PBitVec)
(declare-fun t_93 () PBitVec)
(declare-fun t_92 () PBitVec)
(declare-fun t_91 () PBitVec)
(declare-fun t_90 () PBitVec)
(declare-fun t_89 () PBitVec)
(assert (= (int_to_pbv (pbvsize t_96) 1) (pbvand (pbvand (pbvand (pbvand (pbvand (pbvand (pbvand (pbvand (ite (= t_96 (pbvand t_95 (int_to_pbv (pbvsize t_96) 1))) (int_to_pbv (pbvsize t_96) 1) (int_to_pbv (pbvsize t_96) 0)) (ite (= t_95 (pbvand t_94 (int_to_pbv (pbvsize t_96) 1))) (int_to_pbv (pbvsize t_96) 1) (int_to_pbv (pbvsize t_96) 0))) (ite (= t_94 (pbvand t_93 (int_to_pbv (pbvsize t_96) 1))) (int_to_pbv (pbvsize t_96) 1) (int_to_pbv (pbvsize t_96) 0))) (ite (= t_93 (pbvand t_92 (int_to_pbv (pbvsize t_96) 1))) (int_to_pbv (pbvsize t_96) 1) (int_to_pbv (pbvsize t_96) 0))) (ite (= t_92 (pbvand t_91 (int_to_pbv (pbvsize t_96) 1))) (int_to_pbv (pbvsize t_96) 1) (int_to_pbv (pbvsize t_96) 0))) (ite (= t_91 (pbvand t_90 (int_to_pbv (pbvsize t_96) 1))) (int_to_pbv (pbvsize t_96) 1) (int_to_pbv (pbvsize t_96) 0))) (ite (= t_90 (pbvand t_89 (int_to_pbv (pbvsize t_96) 1))) (int_to_pbv (pbvsize t_96) 1) (int_to_pbv (pbvsize t_96) 0))) (ite (= t_89 (int_to_pbv (pbvsize t_96) 1)) (int_to_pbv (pbvsize t_96) 1) (int_to_pbv (pbvsize t_96) 0))) (pbvand (pbvnot (int_to_pbv (pbvsize t_96) 0)) (pbvor (pbvnot (pbvand t_96 (int_to_pbv (pbvsize t_96) 1))) (int_to_pbv (pbvsize t_96) 1))))))
(check-sat)
(exit)