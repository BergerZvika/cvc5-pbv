; ∀ (x c d : BitVec wa) (wt : Int), wa < wt →
;   zeroExtend wt (x &&& c ||| d) = zeroExtend wt x &&& zeroExtend wt c ||| zeroExtend wt d
(set-logic PBV)
(declare-const wa Int)
(declare-const wt Int)
(declare-const x PBitVec)
(assert (= (pbvsize x) wa))
(declare-const c PBitVec)
(assert (= (pbvsize c) wa))
(declare-const d PBitVec)
(assert (= (pbvsize d) wa))
(assert (< wa wt))
(assert (not (= (pzero_extend (- wt wa) (pbvor (pbvand x c) d)) (pbvor (pbvand (pzero_extend (- wt wa) x) (pzero_extend (- wt wa) c)) (pzero_extend (- wt wa) d)))))
(check-sat)
