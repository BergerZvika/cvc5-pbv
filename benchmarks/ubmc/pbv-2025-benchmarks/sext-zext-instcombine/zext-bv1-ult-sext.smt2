; ∀ (c : BitVec 1) (wt : Int), 1 < wt →
;   ofBool (zeroExtend wt c <ᵤ signExtend wt c) = c
; (c=0: 0 <u 0 = false → 0 = c=0 ✓; c=1: 1 <u -1 = true (since -1 is max unsigned) → 1 = c=1 ✓)
(set-logic PBV)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) 1))
(assert (< 1 wt))
(assert (not (= (ite (pbvult (pzero_extend (- wt 1) c) (psign_extend (- wt 1) c)) (int_to_pbv 1 1) (int_to_pbv 1 0)) c)))
(check-sat)
