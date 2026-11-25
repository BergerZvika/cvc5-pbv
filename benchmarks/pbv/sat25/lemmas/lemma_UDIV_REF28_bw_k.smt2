(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_UDIV_REF28 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (pbvuge x (pbvshl s (pbvnot (pbvxor x t)))))
(assert (= t (pbvudiv x s)))
(assert (not (lemma_UDIV_REF28 x s t)))
(check-sat)
