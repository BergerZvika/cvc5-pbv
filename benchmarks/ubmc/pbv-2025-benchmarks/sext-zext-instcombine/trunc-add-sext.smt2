; ∀ (x : BitVec wa) (y : BitVec wt), wa < wt →
;   truncate wa (signExtend wt x + y) = x + truncate wa y
; (same as trunc-add-zext but for sext; low bits of sext = x)
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(declare-const y PBitVec)
(assert (= (pbvsize y) wt))
(assert (< wa wt))
(assert (not (= (pextract (pbvadd (psign_extend (- wt wa) x) y) (- wa 1) 0) (pbvadd x (pextract y (- wa 1) 0)))))
(check-sat)
