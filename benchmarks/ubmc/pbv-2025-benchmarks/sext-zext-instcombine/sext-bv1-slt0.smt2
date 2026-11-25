; ∀ (c : BitVec 1) (wt : Int), 1 < wt →
;   ofBool (signExtend wt c <ₛ 0) = c
; (sext(0)=0 not <s 0; sext(1)=-1 <s 0; so result = c)
(set-logic PBV)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) 1))
(assert (< 1 wt))
(assert (not (= (ite (pbvslt (psign_extend (- wt 1) c) (int_to_pbv wt 0)) (int_to_pbv 1 1) (int_to_pbv 1 0)) c)))
(check-sat)
