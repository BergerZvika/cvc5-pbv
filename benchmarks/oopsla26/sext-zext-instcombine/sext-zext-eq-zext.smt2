; ∀ (x : BitVec w) (wm wb : Int), w < wm → wm < wb →
;   signExtend wb (zeroExtend wm x) = zeroExtend wb x
; From: sext_zext_apint1_thm (x : BitVec 77), concrete w=77 wm=533 wb=1024
(set-logic PBV)
(declare-const w Int)
(declare-const wm Int)
(declare-const wb Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) w))
(assert (< w wm))
(assert (< wm wb))
(assert (not (= (psign_extend (- wb wm) (pzero_extend (- wm w) x)) (pzero_extend (- wb w) x))))
(check-sat)
