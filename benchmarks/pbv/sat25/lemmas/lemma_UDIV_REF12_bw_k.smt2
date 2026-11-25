(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_UDIV_REF12 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (pbvuge (pbvand x (pbvneg t)) (pbvand s t)))
(assert (= t (pbvudiv x s)))
(assert (not (lemma_UDIV_REF12 x s t)))
(check-sat)
