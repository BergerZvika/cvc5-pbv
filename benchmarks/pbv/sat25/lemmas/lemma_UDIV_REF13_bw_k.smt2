(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_UDIV_REF13 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (pbvuge s (pbvlshr x t)))
(assert (= t (pbvudiv x s)))
(assert (not (lemma_UDIV_REF13 x s t)))
(check-sat)
