(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_MUL_REFN9 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (distinct x (pbvsub (pbvshl x (pbvadd s t)) (int_to_pbv (pbvsize x) 1))))
(assert (= t (pbvmul x s)))
(assert (not (lemma_MUL_REFN9 x s t)))
(check-sat)
