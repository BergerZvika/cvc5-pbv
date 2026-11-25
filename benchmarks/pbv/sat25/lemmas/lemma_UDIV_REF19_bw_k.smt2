(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_UDIV_REF19 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (distinct (pbvlshr x t) (pbvor s t)))
(assert (= t (pbvudiv x s)))
(assert (not (lemma_UDIV_REF19 x s t)))
(check-sat)
