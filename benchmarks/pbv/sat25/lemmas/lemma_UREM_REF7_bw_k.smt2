(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_UREM_REF7 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (= x (pbvand x (pbvor s (pbvor t (pbvneg s))))))
(assert (= t (pbvurem x s)))
(assert (not (lemma_UREM_REF7 x s t)))
(check-sat)
