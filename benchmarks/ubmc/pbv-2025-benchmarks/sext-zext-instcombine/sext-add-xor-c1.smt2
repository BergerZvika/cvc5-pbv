; t0_thm.extracted_1._1
; ∀ (x : BitVec wt) (c : BitVec 1) (wt : Int), 1 < wt → c = 1 →
;   signExtend wt c + x ^^^ signExtend wt c = 0 - x
; (sext(1) = -1; -1 + x = x - 1; (x-1) ^^^ (-1) = ~(x-1) = -(x-1)-1 = -x)
(set-logic PBV)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) 1))
(declare-const x PBitVec)
(assert (= (pbvsize x) wt))
(assert (< 1 wt))
(assert (= c (int_to_pbv 1 1)))
(assert (not (= (pbvxor (pbvadd (psign_extend (- wt 1) c) x) (psign_extend (- wt 1) c)) (pbvsub (int_to_pbv wt 0) x))))
(check-sat)
