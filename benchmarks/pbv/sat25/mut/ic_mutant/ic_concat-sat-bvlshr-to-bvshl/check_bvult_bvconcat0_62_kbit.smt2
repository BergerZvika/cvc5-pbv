(set-logic PBV)

(declare-fun s () PBitVec)
(declare-fun tx () PBitVec)
(declare-fun ts () PBitVec)

(define-fun min () PBitVec
  (pbvnot (pbvshl (pbvnot (int_to_pbv (pbvsize tx) 0)) (int_to_pbv (pbvsize tx) 1)))
)
(define-fun max () PBitVec
  (pbvnot min)
)

(define-fun SC () Bool
(=> (= tx (int_to_pbv (pbvsize tx) 0)) (pbvult s ts))
)

(assert
 (not
  (and
   (=> SC (exists ((x PBitVec)) (pbvult (pconcat x s) (pconcat tx ts))))
   (=> (exists ((x PBitVec)) (pbvult (pconcat x s) (pconcat tx ts))) SC)
  )
 )
)
(check-sat)
