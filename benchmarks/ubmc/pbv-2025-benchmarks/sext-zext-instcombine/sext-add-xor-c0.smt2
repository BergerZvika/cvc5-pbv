; t0_thm.extracted_1._2
; ∀ (x : BitVec wt) (c : BitVec 1) (wt : Int), 1 < wt → c ≠ 1 →
;   signExtend wt c + x ^^^ signExtend wt c = x
; (sext(0) = 0; 0 + x = x; x ^^^ 0 = x)
(set-logic PBV)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) 1))
(declare-const x PBitVec)
(assert (= (pbvsize x) wt))
(assert (< 1 wt))
(assert (not (= c (int_to_pbv 1 1))))
(assert (not (= (pbvxor (pbvadd (psign_extend (- wt 1) c) x) (psign_extend (- wt 1) c)) x)))
(check-sat)
