; ∀ (c : BitVec 1) (wt : Int), 1 < wt →
;   ofBool (zeroExtend wt c <ᵤ 2) = 1
; (zext(0)=0<2; zext(1)=1<2)
(set-logic PBV)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) 1))
(assert (< 1 wt))
(assert (< 1 wt))
(assert (not (= (ite (pbvult (pzero_extend (- wt 1) c) (int_to_pbv wt 2)) (int_to_pbv 1 1) (int_to_pbv 1 0)) (int_to_pbv 1 1))))
(check-sat)
