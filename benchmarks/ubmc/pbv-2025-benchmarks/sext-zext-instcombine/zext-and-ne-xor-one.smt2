; ∀ (a b : BitVec w) (wt : Int), w < wt →
;   zeroExtend wt (ofBool (a != 0) &&& ofBool (b != 0)) ^^^ 1#wt
;   = zeroExtend wt (ofBool (a == 0) ||| ofBool (b == 0))
; From: PR28476_thm (x x_1 : BitVec 32), concrete wt=32
(set-logic PBV)
(declare-const w Int)
(declare-const wt Int)
(declare-const a PBitVec)
(assert (= (pbvsize a) w))
(declare-const b PBitVec)
(assert (= (pbvsize b) w))
(assert (< w wt))
(assert (not (= (pbvxor (pzero_extend (- wt 1) (pbvand (ite (distinct a (int_to_pbv w 0)) (int_to_pbv 1 1) (int_to_pbv 1 0)) (ite (distinct b (int_to_pbv w 0)) (int_to_pbv 1 1) (int_to_pbv 1 0)))) (int_to_pbv wt 1)) (pzero_extend (- wt 1) (pbvor (ite (= a (int_to_pbv w 0)) (int_to_pbv 1 1) (int_to_pbv 1 0)) (ite (= b (int_to_pbv w 0)) (int_to_pbv 1 1) (int_to_pbv 1 0)))))))
(check-sat)
