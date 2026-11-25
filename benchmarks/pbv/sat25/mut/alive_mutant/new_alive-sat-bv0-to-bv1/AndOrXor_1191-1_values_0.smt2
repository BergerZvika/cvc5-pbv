(set-logic PBV)
(declare-fun %op0RHS () PBitVec)
(assert (and (pbvult %op0RHS (int_to_pbv (pbvsize %op0RHS) (pbvsize %op0RHS))) (not (= (pbvand (pbvshl (int_to_pbv (pbvsize %op0RHS) 1) %op0RHS) (int_to_pbv (pbvsize %op0RHS) 1)) (pzero_extend (- (pbvsize %op0RHS) 1) (ite (= %op0RHS (int_to_pbv (pbvsize %op0RHS) 1)) (int_to_pbv 1 1) (int_to_pbv 1 0)))))))
(check-sat)