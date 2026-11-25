(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_UREM_REF10 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (distinct t (pbvor (pbvnot x) (pbvneg s))))
(assert (= t (pbvurem x s)))
(assert (not (lemma_UREM_REF10 x s t)))
(check-sat)
