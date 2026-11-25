; ∀ (c : BitVec 1) (wt : Int), 1 < wt →
;   ofBool (signExtend wt c <ₛ zeroExtend wt c) = c
; (c=0: 0 <s 0 = false → 0=c ✓; c=1: -1 <s 1 = true → 1=c ✓)
(set-logic PBV)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) 1))
(assert (< 1 wt))
(assert (not (= (ite (pbvslt (psign_extend (- wt 1) c) (pzero_extend (- wt 1) c)) (int_to_pbv 1 1) (int_to_pbv 1 0)) c)))
(check-sat)
