; lowmask_mul_zext_thm
; ∀ (x : BitVec wa) (y : BitVec wt), wa < wt →
;   (zeroExtend wt x * y) &&& lowmask(wa,wt)
;   = zeroExtend wt (x * truncate wa y)
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(declare-const y PBitVec)
(assert (= (pbvsize y) wt))
(assert (< wa wt))
(assert (not (= (pbvand (pbvmul (pzero_extend (- wt wa) x) y) (pzero_extend (- wt wa) (pbvnot (int_to_pbv wa 0)))) (pzero_extend (- wt wa) (pbvmul x (pextract y (- wa 1) 0))))))
(check-sat)
