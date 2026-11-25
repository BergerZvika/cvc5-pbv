; ∀ (x : BitVec wt) (wa wm : Int), wa < wm → wm < wt →
;   truncate wa (signExtend wt (truncate wm x)) = truncate wa x
; (trunc(wm) keeps low wm bits; sext extends from wm to wt; trunc(wa) takes low wa bits;
;  net result: same as just taking low wa bits of x)
(set-logic PBV)
(declare-const wa Int)
(declare-const wm Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wt))
(assert (< wa wm))
(assert (< wm wt))
(assert (not (= (pextract (psign_extend (- wt wm) (pextract x (- wm 1) 0)) (- wa 1) 0) (pextract x (- wa 1) 0))))
(check-sat)
