(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_UREM_REF5 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (=> (pbvult x s) (= t x)))
(assert (= t (pbvurem x s)))
(assert (not (lemma_UREM_REF5 x s t)))
(check-sat)
