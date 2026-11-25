(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_UDIV_REF15 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (pbvuge x (pbvlshr (pbvshl t (int_to_pbv (pbvsize x) 1)) (pbvshl t s))))
(assert (= t (pbvudiv x s)))
(assert (not (lemma_UDIV_REF15 x s t)))
(check-sat)
