; lowmask_or_zext_commute_thm
; ∀ (x : BitVec wa) (y : BitVec wt), wa < wt →
;   (y ||| zeroExtend wt x) &&& lowmask(wa,wt)
;   = zeroExtend wt (x ||| truncate wa y)
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(declare-const y PBitVec)
(assert (= (pbvsize y) wt))
(assert (< wa wt))
(assert (not (= (pbvand (pbvor y (pzero_extend (- wt wa) x)) (pzero_extend (- wt wa) (pbvnot (int_to_pbv wa 0)))) (pzero_extend (- wt wa) (pbvor x (pextract y (- wa 1) 0))))))
(check-sat)
