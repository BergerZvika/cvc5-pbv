(set-logic PBV)

(declare-fun s () PBitVec)
(declare-fun tx () PBitVec)
(declare-fun ts () PBitVec)

(define-fun min () PBitVec
  (pbvnot (pbvlshr (pbvnot (int_to_pbv (pbvsize tx) 0)) (int_to_pbv (pbvsize tx) 0)))
)
(define-fun max () PBitVec
  (pbvnot min)
)

(define-fun SC () Bool
(= s ts)
)

(assert
 (not
  (and
   (=> SC (exists ((x PBitVec)) (= (pconcat x s) (pconcat tx ts))))
   (=> (exists ((x PBitVec)) (= (pconcat x s) (pconcat tx ts))) SC)
  )
 )
)
(check-sat)
