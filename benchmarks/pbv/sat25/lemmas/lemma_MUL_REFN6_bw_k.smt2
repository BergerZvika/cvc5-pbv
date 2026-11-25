(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_MUL_REFN6 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (distinct x (pbvxor (int_to_pbv (pbvsize x) 1) (pbvshl x (pbvxor s t)))))
(assert (= t (pbvmul x s)))
(assert (not (lemma_MUL_REFN6 x s t)))
(check-sat)
