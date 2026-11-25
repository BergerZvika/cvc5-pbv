(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_UDIV_REF14 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (pbvuge x (pbvshl (pbvlshr s (pbvshl s t)) (int_to_pbv (pbvsize x) 1))))
(assert (= t (pbvudiv x s)))
(assert (not (lemma_UDIV_REF14 x s t)))
(check-sat)
