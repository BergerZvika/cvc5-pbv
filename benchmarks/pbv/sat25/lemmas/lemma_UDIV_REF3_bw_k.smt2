(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_UDIV_REF3 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (=> (= s (int_to_pbv (pbvsize x) 0)) (= t (pbvnot (int_to_pbv (pbvsize x) 0)))))
(assert (= t (pbvudiv x s)))
(assert (not (lemma_UDIV_REF3 x s t)))
(check-sat)
