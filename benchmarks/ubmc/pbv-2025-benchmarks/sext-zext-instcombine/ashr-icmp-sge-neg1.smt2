; ∀ (x : BitVec w), 1 ≤ w →
;   x.sshiftRight'(w - 1) &&& zeroExtend w (ofBool (-1 ≤ₛ x)) = zeroExtend w (ofBool (x == -1#w))
; From: ashr_and_icmp_sge_neg1_i64_thm (x : BitVec 64), concrete width 64
(set-logic PBV)
(declare-const w Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) w))
(assert (<= 1 w))
(assert (not (= (pbvand (pbvashr x (int_to_pbv w (- w 1))) (pzero_extend (- w 1) (ite (pbvsle (pbvnot (int_to_pbv w 0)) x) (int_to_pbv 1 1) (int_to_pbv 1 0)))) (pzero_extend (- w 1) (ite (= x (pbvnot (int_to_pbv w 0))) (int_to_pbv 1 1) (int_to_pbv 1 0))))))
(check-sat)
