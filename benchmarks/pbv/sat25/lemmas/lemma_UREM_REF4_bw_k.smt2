(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_UREM_REF4 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (=> (= s x) (= t (int_to_pbv (pbvsize x) 0))))
(assert (= t (pbvurem x s)))
(assert (not (lemma_UREM_REF4 x s t)))
(check-sat)
