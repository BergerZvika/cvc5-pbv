(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_UDIV_REF9 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (distinct t (pbvneg (pbvand s (pbvnot x)))))
(assert (= t (pbvudiv x s)))
(assert (not (lemma_UDIV_REF9 x s t)))
(check-sat)
