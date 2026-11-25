; ∀ (c1 c2 : BitVec 1) (wt : Int), 1 < wt →
;   signExtend wt c1 + zeroExtend wt c2 = zeroExtend wt c2 - zeroExtend wt c1
; (sext(c1)=-1*c1=-c1=-zext(c1); so sext(c1)+zext(c2)=zext(c2)-zext(c1))
(set-logic PBV)
(declare-const wt Int)
(declare-const c1 PBitVec)
(assert (= (pbvsize c1) 1))
(declare-const c2 PBitVec)
(assert (= (pbvsize c2) 1))
(assert (< 1 wt))
(assert (not (= (pbvadd (psign_extend (- wt 1) c1) (pzero_extend (- wt 1) c2)) (pbvsub (pzero_extend (- wt 1) c2) (pzero_extend (- wt 1) c1)))))
(check-sat)
