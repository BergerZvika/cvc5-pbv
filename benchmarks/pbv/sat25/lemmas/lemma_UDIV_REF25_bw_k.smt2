(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_UDIV_REF25 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (pbvuge x (pbvshl t (pbvnot (pbvor x s)))))
(assert (= t (pbvudiv x s)))
(assert (not (lemma_UDIV_REF25 x s t)))
(check-sat)
