; lowmask_sub_zext_commute_thm
; ∀ (x : BitVec wa) (y : BitVec wt), wa < wt →
;   (y - zeroExtend wt x) &&& lowmask(wa,wt)
;   = zeroExtend wt (truncate wa y - x)
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(declare-const y PBitVec)
(assert (= (pbvsize y) wt))
(assert (< wa wt))
(assert (not (= (pbvand (pbvsub y (pzero_extend (- wt wa) x)) (pzero_extend (- wt wa) (pbvnot (int_to_pbv wa 0)))) (pzero_extend (- wt wa) (pbvsub (pextract y (- wa 1) 0) x)))))
(check-sat)
