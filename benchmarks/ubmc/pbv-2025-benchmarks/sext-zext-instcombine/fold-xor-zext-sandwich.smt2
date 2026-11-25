; ∀ (x : BitVec 1) (wm wb : Int), 1 ≤ wm → wm ≤ wb →
;   zeroExtend wb (zeroExtend wm x ^^^ 1#wm) = zeroExtend wb (x ^^^ 1#1)
; From: fold_xor_zext_sandwich_thm (x : BitVec 1), concrete wm=32 wb=64
(set-logic PBV)
(declare-const wm Int)
(declare-const wb Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(assert (<= 1 wm))
(assert (<= wm wb))
(assert (not (= (pzero_extend (- wb wm) (pbvxor (pzero_extend (- wm 1) x) (int_to_pbv wm 1))) (pzero_extend (- wb 1) (pbvxor x (int_to_pbv 1 1))))))
(check-sat)
