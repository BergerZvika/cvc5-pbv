; sext_diff_i1_xor_sub_thm (overflow-free case)
; ∀ (x x1 : BitVec 1) (wt : Int), 1 < wt →
;   signExtend wt x1 - signExtend wt x = zeroExtend wt x + signExtend wt x1
; (x=0: sext(0)=0; sext(x1)-0=sext(x1); 0+sext(x1)=sext(x1) ✓)
; (x=1: sext(1)=-1; sext(x1)-(-1)=sext(x1)+1; 1+sext(x1)=sext(x1)+1 ✓)
(set-logic PBV)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) 1))
(declare-const x1 PBitVec)
(assert (= (pbvsize x1) 1))
(assert (< 1 wt))
(assert (not (= (pbvsub (psign_extend (- wt 1) x1) (psign_extend (- wt 1) x)) (pbvadd (pzero_extend (- wt 1) x) (psign_extend (- wt 1) x1)))))
(check-sat)
