(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_UDIV_REF30 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (distinct x (pbvadd t (pbvor s (pbvadd x s)))))
(assert (= t (pbvudiv x s)))
(assert (not (lemma_UDIV_REF30 x s t)))
(check-sat)
