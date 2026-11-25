; ∀ (c : BitVec 1) (wt : Int), 1 < wt →
;   ofBool (zeroExtend wt c >ₛ signExtend wt c) = c
(set-logic PBV)
(declare-const wt Int)
(declare-const c PBitVec)
(assert (= (pbvsize c) 1))
(assert (< 1 wt))
(assert (not (= (ite (pbvsgt (pzero_extend (- wt 1) c) (psign_extend (- wt 1) c)) (int_to_pbv 1 1) (int_to_pbv 1 0)) c)))
(check-sat)
