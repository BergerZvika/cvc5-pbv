(set-logic PBV)

(declare-const x PBitVec)
(declare-const s PBitVec)
(declare-const t PBitVec)
(define-fun lemma_MUL_REF13 ((x PBitVec) (s PBitVec) (t PBitVec)) Bool (distinct t (pbvor (int_to_pbv (pbvsize x) 1) (pbvadd x s))))

(assert (= t (pbvmul x s)))
(assert (not (lemma_MUL_REF13 x s t)))
(assert (> (pbvsize x) 1))
(check-sat)
