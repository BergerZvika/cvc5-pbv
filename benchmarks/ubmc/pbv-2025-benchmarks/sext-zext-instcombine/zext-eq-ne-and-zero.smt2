; ∀ (a b : BitVec w) (wt : Int), w < wt →
;   zeroExtend wt (ofBool (a == b)) &&& zeroExtend wt (ofBool (a != b)) = 0
; (a==b and a!=b cannot both be true)
(set-logic PBV)
(declare-const w Int)
(declare-const wt Int)
(declare-const a PBitVec)
(assert (= (pbvsize a) w))
(declare-const b PBitVec)
(assert (= (pbvsize b) w))
(assert (< w wt))
(assert (not (= (pbvand (pzero_extend (- wt 1) (ite (= a b) (int_to_pbv 1 1) (int_to_pbv 1 0))) (pzero_extend (- wt 1) (ite (= a b) (int_to_pbv 1 0) (int_to_pbv 1 1)))) (int_to_pbv wt 0))))
(check-sat)
