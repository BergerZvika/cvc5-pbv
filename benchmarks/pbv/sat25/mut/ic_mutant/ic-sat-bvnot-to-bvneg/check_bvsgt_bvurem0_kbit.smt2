(set-logic PBV)

(declare-fun s () PBitVec)
(declare-fun t () PBitVec)

(define-fun udivtotal ((a PBitVec) (b PBitVec)) PBitVec
  (ite (= b (int_to_pbv (pbvsize s) 0)) (pbvneg (int_to_pbv (pbvsize s) 0)) (pbvudiv a b))
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
(and (and (=> (pbvsgt s (int_to_pbv (pbvsize s) 0)) (pbvslt t (pbvnot (pbvneg s)))) (=> (pbvsle s (int_to_pbv (pbvsize s) 0)) (distinct t max))) (or (distinct t (int_to_pbv (pbvsize s) 0)) (distinct s (int_to_pbv (pbvsize s) 1))))
)

(assert
 (not
  (and
  (=> (SC s t) (exists ((x PBitVec)) (pbvsgt (uremtotal x s) t)))
  (=> (exists ((x PBitVec)) (pbvsgt (uremtotal x s) t)) (SC s t))
  )
 )
)
(check-sat)
