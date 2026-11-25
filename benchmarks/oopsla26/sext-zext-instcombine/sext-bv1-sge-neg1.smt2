; ∀ (c : BitVec 1) (wt : Int), 1 < wt →
;   ofBool (signExtend wt c >=ₛ -1) = 1
; (sext(0)=0 >=s -1 ✓; sext(1)=-1 >=s -1 ✓)
(set-logic PBV)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) 1))
(assert (< 1 wt))
(assert (not (= (ite (pbvsge (psign_extend (- wt 1) c) (pbvnot (int_to_pbv wt 0))) (int_to_pbv 1 1) (int_to_pbv 1 0)) (int_to_pbv 1 1))))
(check-sat)
