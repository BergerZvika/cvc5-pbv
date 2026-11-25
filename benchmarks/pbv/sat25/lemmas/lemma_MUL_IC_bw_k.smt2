(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_MUL_IC ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (= (pbvand (pbvor (pbvneg s) s) t) t))
(assert (= t (pbvmul x s)))
(assert (not (lemma_MUL_IC x s t)))
(check-sat)
