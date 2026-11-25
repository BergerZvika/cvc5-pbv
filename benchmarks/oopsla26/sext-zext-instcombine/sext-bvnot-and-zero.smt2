; ∀ (x : BitVec wa) (wt : Int), wa < wt →
;   signExtend wt (bvnot x) &&& signExtend wt x = 0
; (sext(bvnot x) = bvnot(sext x); bvnot(y) &&& y = 0)
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wt))
(assert (not (= (pbvand (psign_extend (- wt wa) (pbvnot x)) (psign_extend (- wt wa) x)) (int_to_pbv wt 0))))
(check-sat)
