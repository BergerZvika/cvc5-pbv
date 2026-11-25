(set-logic PBV)
(set-option :produce-models true)

(declare-fun s () PBitVec)
(declare-fun tx () PBitVec)
(declare-fun ts () PBitVec)

(define-fun min () PBitVec
  (pbvnot (pbvlshr (pbvnot (int_to_pbv (pbvsize tx) 0)) (int_to_pbv (pbvsize tx) 1)))
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
