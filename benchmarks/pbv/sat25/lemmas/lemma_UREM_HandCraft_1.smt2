(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(declare-const i Int)
(define-fun lemma_UREM_HC1 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (=> (= s (pbvshl (int_to_pbv (pbvsize x) 1) (int_to_pbv (pbvsize x) i))) (= t (pconcat (int_to_pbv (- (pbvsize x) i) 0) (pextract x (- i 1) 0)))))
(assert (>= i 0))
(assert (< i (pbvsize x)))
(assert (= t (pbvurem x s)))
(assert (not (lemma_UREM_HC1 x s t)))
(check-sat)

