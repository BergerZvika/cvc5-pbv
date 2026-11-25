(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_MUL_REFN11 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (distinct s (pbvadd (int_to_pbv (pbvsize x) 1) (pbvshl s (pbvsub t x)))))
(assert (= t (pbvmul x s)))
(assert (not (lemma_MUL_REFN11 x s t)))
(check-sat)
