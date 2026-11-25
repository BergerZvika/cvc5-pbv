(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_UREM_REF2 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (=> (= x (int_to_pbv (pbvsize x) 1)) (= t (int_to_pbv (pbvsize x) 0))))
(assert (= t (pbvurem x s)))
(assert (not (lemma_UREM_REF2 x s t)))
(check-sat)
