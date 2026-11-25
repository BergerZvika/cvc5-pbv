; ∀ (c : BitVec 1) (wt : Int), 1 < wt →
;   zeroExtend wt c + signExtend wt c + 1 = 1
; (zext+sext=0, so +1=1)
(set-logic PBV)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) 1))
(assert (< 1 wt))
(assert (not (= (pbvadd (pbvadd (pzero_extend (- wt 1) c) (psign_extend (- wt 1) c)) (int_to_pbv wt 1)) (int_to_pbv wt 1))))
(check-sat)
