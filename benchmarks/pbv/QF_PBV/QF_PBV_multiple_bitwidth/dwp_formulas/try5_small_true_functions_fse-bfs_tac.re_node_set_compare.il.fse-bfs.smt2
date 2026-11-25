(set-info :smt-lib-version 2.6)
(set-logic PBV)
(declare-fun pbv_w_1 () Int)
(assert (>= pbv_w_1 1))
(declare-fun pbv_w_31 () Int)
(assert (>= pbv_w_31 1))
(set-info :source |
Ivan Jager <aij+nospam@andrew.cmu.edu>

|)
(set-info :category "industrial")
(set-info :status sat)
(declare-fun R_EDX_8_82 () PBitVec)
(declare-fun R_EAX_5_56 () PBitVec)
(assert (let ((?v_0 (pextract (pconcat (int_to_pbv pbv_w_31 0) (ite (= R_EAX_5_56 (int_to_pbv (pbvsize R_EAX_5_56) 0)) (int_to_pbv pbv_w_1 1) (int_to_pbv pbv_w_1 0))) 0 0))) (= (int_to_pbv (pbvsize (pbvor (pbvand (int_to_pbv (pbvsize (pbvand (pextract (pconcat (int_to_pbv pbv_w_31 0) (ite (= R_EDX_8_82 (int_to_pbv (pbvsize R_EDX_8_82) 0)) (int_to_pbv pbv_w_1 1) (int_to_pbv pbv_w_1 0))) 0 0) (pbvand (pbvnot ?v_0) (int_to_pbv (pbvsize (pbvnot ?v_0)) 1)))) 1) (pbvand (pextract (pconcat (int_to_pbv pbv_w_31 0) (ite (= R_EDX_8_82 (int_to_pbv (pbvsize R_EDX_8_82) 0)) (int_to_pbv pbv_w_1 1) (int_to_pbv pbv_w_1 0))) 0 0) (pbvand (pbvnot ?v_0) (int_to_pbv (pbvsize (pbvnot ?v_0)) 1)))) (pbvand (int_to_pbv (pbvsize (pbvand ?v_0 (int_to_pbv (pbvsize ?v_0) 1))) 1) (pbvand ?v_0 (int_to_pbv (pbvsize ?v_0) 1))))) 1) (pbvor (pbvand (int_to_pbv (pbvsize (pbvand (pextract (pconcat (int_to_pbv pbv_w_31 0) (ite (= R_EDX_8_82 (int_to_pbv (pbvsize R_EDX_8_82) 0)) (int_to_pbv pbv_w_1 1) (int_to_pbv pbv_w_1 0))) 0 0) (pbvand (pbvnot ?v_0) (int_to_pbv (pbvsize (pbvnot ?v_0)) 1)))) 1) (pbvand (pextract (pconcat (int_to_pbv pbv_w_31 0) (ite (= R_EDX_8_82 (int_to_pbv (pbvsize R_EDX_8_82) 0)) (int_to_pbv pbv_w_1 1) (int_to_pbv pbv_w_1 0))) 0 0) (pbvand (pbvnot ?v_0) (int_to_pbv (pbvsize (pbvnot ?v_0)) 1)))) (pbvand (int_to_pbv (pbvsize (pbvand ?v_0 (int_to_pbv (pbvsize ?v_0) 1))) 1) (pbvand ?v_0 (int_to_pbv (pbvsize ?v_0) 1)))))))
(check-sat)
(exit)