; ∀ (x : BitVec w) (wt : Int), w < wt →
;   zeroExtend wt (ofBool (x <ₛ 0)) ||| zeroExtend wt (ofBool (0 <ₛ x))
;   = zeroExtend wt (ofBool (x != 0))
; From: icmp_slt_0_or_icmp_sgt_0_i32_thm (x : BitVec 32), concrete wt=32
(set-logic PBV)
(declare-const w Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) w))
(assert (< w wt))
(assert (not (= (pbvor (pzero_extend (- wt 1) (ite (pbvslt x (int_to_pbv w 0)) (int_to_pbv 1 1) (int_to_pbv 1 0))) (pzero_extend (- wt 1) (ite (pbvslt (int_to_pbv w 0) x) (int_to_pbv 1 1) (int_to_pbv 1 0)))) (pzero_extend (- wt 1) (ite (distinct x (int_to_pbv w 0)) (int_to_pbv 1 1) (int_to_pbv 1 0))))))
(check-sat)
