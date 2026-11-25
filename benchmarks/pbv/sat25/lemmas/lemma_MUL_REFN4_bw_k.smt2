(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_MUL_REFN4 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (= s (pbvshl s (pbvand x (pbvlshr (int_to_pbv (pbvsize x) 1) t)))))
(assert (= t (pbvmul x s)))
(assert (not (lemma_MUL_REFN4 x s t)))
(check-sat)
