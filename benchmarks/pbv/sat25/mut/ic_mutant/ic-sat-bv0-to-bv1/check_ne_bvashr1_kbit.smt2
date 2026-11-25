(set-logic PBV)

(declare-fun s () PBitVec)
(declare-fun t () PBitVec)

(define-fun udivtotal ((a PBitVec) (b PBitVec)) PBitVec
  (ite (= b (int_to_pbv (pbvsize s) 1)) (pbvnot (int_to_pbv (pbvsize s) 0)) (pbvudiv a b))
)
(define-fun uremtotal ((a PBitVec) (b PBitVec)) PBitVec
  (ite (= b (int_to_pbv (pbvsize s) 0)) a (pbvurem a b))
)
(define-fun min () PBitVec
  (pbvnot (pbvlshr (pbvnot (int_to_pbv (pbvsize s) 0)) (int_to_pbv (pbvsize s) 1)))
)
(define-fun max () PBitVec
  (pbvnot min)
)

(define-fun SC ((s PBitVec) (t PBitVec)) Bool
(and (or (not (= t (int_to_pbv (pbvsize s) 0))) (not (= s (int_to_pbv (pbvsize s) 0)))) (or (not (= t (pbvnot (int_to_pbv (pbvsize s) 0)))) (not (= s (pbvnot (int_to_pbv (pbvsize s) 0))))))
)

(assert
 (not
  (and
  (=> (SC s t) (exists ((x PBitVec)) (distinct (pbvashr s x) t)))
  (=> (exists ((x PBitVec)) (distinct (pbvashr s x) t)) (SC s t))
  )
 )
)
(check-sat)
