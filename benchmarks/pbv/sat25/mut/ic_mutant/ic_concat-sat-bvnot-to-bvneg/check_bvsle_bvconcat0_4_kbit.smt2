(set-logic PBV)

(declare-fun s () PBitVec)
(declare-fun tx () PBitVec)
(declare-fun ts () PBitVec)

(define-fun min () PBitVec
  (pbvneg (pbvlshr (pbvnot (int_to_pbv (pbvsize s) 0)) (int_to_pbv (pbvsize s) 1)))
)
(define-fun max () PBitVec
  (pbvnot min)
)

(define-fun SC () Bool
(=> (= tx min) (pbvule s ts))
)

(assert
 (not
  (and
   (=> SC (exists ((x PBitVec)) (pbvsle (pconcat x s) (pconcat tx ts))))
   (=> (exists ((x PBitVec)) (pbvsle (pconcat x s) (pconcat tx ts))) SC)
  )
 )
)
(check-sat)
