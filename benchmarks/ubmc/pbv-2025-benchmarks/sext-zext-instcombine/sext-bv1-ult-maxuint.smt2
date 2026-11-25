; ∀ (c : BitVec 1) (wt : Int), 1 < wt →
;   ofBool (signExtend wt c <ᵤ bvnot (int_to_pbv wt 0)) = bvnot c
; (sext(0)=0 <u max=true → 1=bvnot(0); sext(1)=-1=max not <u max → 0=bvnot(1))
(set-logic PBV)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) 1))
(assert (< 1 wt))
(assert (not (= (ite (pbvult (psign_extend (- wt 1) c) (pbvnot (int_to_pbv wt 0))) (int_to_pbv 1 1) (int_to_pbv 1 0)) (pbvnot c))))
(check-sat)
