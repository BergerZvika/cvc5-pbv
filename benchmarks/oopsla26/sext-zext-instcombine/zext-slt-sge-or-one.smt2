; ∀ (a b : BitVec w) (wt : Int), w < wt →
;   zeroExtend wt (ofBool (a <ₛ b)) ||| zeroExtend wt (ofBool (b <=ₛ a)) = 1
(set-logic PBV)
(declare-const w Int)
(declare-const wt Int)
(declare-const a PBitVec)
(assert (= (pbvsize a) w))
(declare-const b PBitVec)
(assert (= (pbvsize b) w))
(assert (< w wt))
(assert (not (= (pbvor (pzero_extend (- wt 1) (ite (pbvslt a b) (int_to_pbv 1 1) (int_to_pbv 1 0))) (pzero_extend (- wt 1) (ite (pbvsle b a) (int_to_pbv 1 1) (int_to_pbv 1 0)))) (int_to_pbv wt 1))))
(check-sat)
