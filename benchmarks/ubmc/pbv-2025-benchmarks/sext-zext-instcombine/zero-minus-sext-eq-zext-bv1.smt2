; test17_thm (generalized)
; ∀ (x : BitVec 1) (wt : Int), 1 < wt →
;   0 - signExtend wt x = zeroExtend wt x
; (c=0: 0-0=0=zext(0); c=1: 0-(-1)=1=zext(1))
(set-logic PBV)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(assert (< 1 wt))
(assert (not (= (pbvsub (int_to_pbv wt 0) (psign_extend (- wt 1) x)) (pzero_extend (- wt 1) x))))
(check-sat)
