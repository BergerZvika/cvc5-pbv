; absdiff1_thm.extracted_1._1 (generalized)
; ∀ (a b : BitVec wt) (wt : Int), 1 < wt → b <ᵤ a →
;   ((a - b) ^^^ signExtend wt (ofBool (b <ᵤ a))) - signExtend wt (ofBool (b <ᵤ a))
;   = b - a
(set-logic PBV)
(declare-const wt Int)
(declare-const a PBitVec)
(assert (= (pbvsize a) wt))
(declare-const b PBitVec)
(assert (= (pbvsize b) wt))
(assert (< 1 wt))
(assert (pbvult b a))
(assert (not (= (pbvsub (pbvxor (pbvsub a b) (psign_extend (- wt 1) (ite (pbvult b a) (int_to_pbv 1 1) (int_to_pbv 1 0)))) (psign_extend (- wt 1) (ite (pbvult b a) (int_to_pbv 1 1) (int_to_pbv 1 0)))) (pbvsub b a))))
(check-sat)
