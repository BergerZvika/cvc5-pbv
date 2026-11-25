; ∀ (x : BitVec wa), wa < wm → wm ≤ wb → 1 < wa →
;   truncate wm (signExtend wb x >>> 1) = signExtend wm (x.sshiftRight' 1)
; From: PR24763_thm (x : BitVec 8), concrete widths 8 < 16 ≤ 32, shift 1 < 8
(set-logic PBV)
(declare-const wa Int)
(declare-const wm Int)
(declare-const wb Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wm))
(assert (<= wm wb))
(assert (< 1 wa))
(assert (not (= (pextract (pbvlshr (psign_extend (- wb wa) x) (int_to_pbv wb 1)) (- wm 1) 0) (psign_extend (- wm wa) (pbvashr x (int_to_pbv wa 1))))))
(check-sat)
