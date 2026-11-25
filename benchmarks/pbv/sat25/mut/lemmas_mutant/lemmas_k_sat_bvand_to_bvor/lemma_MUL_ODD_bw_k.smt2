(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_MUL_ODD ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (= (pextract t 0 0) (pbvor (pextract x 0 0) (pextract s 0 0))))
(assert (= t (pbvmul x s)))
(assert (not (lemma_MUL_ODD x s t)))
(check-sat)
