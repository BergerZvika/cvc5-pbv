; ∀ (c : BitVec 1) (wt : Int), 1 < wt →
;   ofBool (signExtend wt c == bvnot (int_to_pbv wt 0)) = c
; (sext(1)=-1=allones → true → 1=c; sext(0)=0≠-1 → false → 0=c)
(set-logic PBV)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) 1))
(assert (< 1 wt))
(assert (not (= (ite (= (psign_extend (- wt 1) c) (pbvnot (int_to_pbv wt 0))) (int_to_pbv 1 1) (int_to_pbv 1 0)) c)))
(check-sat)
