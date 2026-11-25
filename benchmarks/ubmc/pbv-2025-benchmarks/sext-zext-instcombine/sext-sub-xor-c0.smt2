; sext_xor_sub_2_thm.extracted_1._2
; ∀ (x : BitVec wt) (c : BitVec 1) (wt : Int), 1 < wt → c ≠ 1 →
;   signExtend wt c - (x ^^^ signExtend wt c) = 0 - x
; (sext(0) = 0; 0 - (x ^^^ 0) = 0 - x = -x)
(set-logic PBV)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) 1))
(declare-const x PBitVec)
(assert (= (pbvsize x) wt))
(assert (< 1 wt))
(assert (not (= c (int_to_pbv 1 1))))
(assert (not (= (pbvsub (psign_extend (- wt 1) c) (pbvxor x (psign_extend (- wt 1) c))) (pbvsub (int_to_pbv wt 0) x))))
(check-sat)
