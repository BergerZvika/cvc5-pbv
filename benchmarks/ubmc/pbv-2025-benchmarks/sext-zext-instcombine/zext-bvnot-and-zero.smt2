; ∀ (x : BitVec wa) (wt : Int), wa < wt →
;   zeroExtend wt (bvnot x) &&& zeroExtend wt x = 0
; (bvnot(x) &&& x = 0, and zext distributes through AND)
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(assert (< wa wt))
(assert (not (= (pbvand (pzero_extend (- wt wa) (pbvnot x)) (pzero_extend (- wt wa) x)) (int_to_pbv wt 0))))
(check-sat)
